
package.path = package.path..";/home/pi/domoticz/scripts/lua/modules/?.lua"
require 'Properties_class'

Day = {}
Day.__index = Day

function Day.create()
   local mrt = {}             -- our new object
   setmetatable(mrt,Day)  -- make handle lookup
   mrt.jourChomeToday="NULL" -- Variable globale (date du dernier calcul) pour ne pas recalculer le résultat à chaque appel
   mrt.veilleJourChomeToday="NULL"
   mrt.weekendToday="NULL"
   mrt.jourChomeReturn=false -- Variable globale (résulat du dernier calcul) pour ne pas recalculer le résultat à chaque appel
   mrt.veilleJourChomeReturn=false
   mrt.getJourSemaineTab={[0]="Dimanche",[1]="Lundi",[2]="Mardi",[3]="Mercredi",[4]="Jeudi",[5]="Vendredi",[6]="Samedi"}
   return mrt
end

-- Retourne true si le jour courant est un jour chômé (passé à la maison)
-- Le calcul effectif n'est fait qu'une fois par jour (ou si Domoticz reboot)

function Day:jourChome()
  local today=os.date("%Y-%m-%d")
  if(today~=self.jourChomeToday) then -- Faut-il refaire le calcul ?
    local jour=self:getJourSemaine()
    self.jourChomeToday=today
    self.jourChomeReturn=(self:weekend() or self:jourFerie())
  end
  return self.jourChomeReturn
end

function Day:weekend()
  local today=os.date("%Y-%m-%d")
  if(today~=self.weekendToday) then -- Faut-il refaire le calcul ?
    local jour=self:getJourSemaine()
    self.weekendToday=today
    self.weekendReturn=(jour=="Samedi" or jour=="Dimanche")
  end
  return self.weekendReturn
end

function Day:veilleJourChome()
  local today=os.date("%Y-%m-%d")
  if(today~=self.veilleJourChomeToday) then -- Faut-il refaire le calcul ?
    local jour=self:getJourSemaine()
    self.veilleJourChomeToday=today
    self.veilleJourChomeReturn=(jour=="Vendredi" or jour=="Samedi")
  end
  return self.veilleJourChomeReturn
end

function Day:initJoursChome()	 
--print(string.sub(uservariables_lastupdate['jourChome'],0,10))

time=os.time()
isDay=os.date('%Y-%m-%d',time)
if( isDay ~= string.sub(uservariables_lastupdate['jourChome'],0,10) ) then
	
	if(self:jourChome()) then 
		commandArray['Variable:jourChome'] ='1'
	else
		commandArray['Variable:jourChome'] ='0'
	end
end

if( isDay ~= string.sub(uservariables_lastupdate['veilleJourChome'],0,10) ) then
	if(self:veilleJourChome()) then 
		commandArray['Variable:veilleJourChome'] ='1'
	else
		commandArray['Variable:veilleJourChome'] ='0'
	end
end

if( isDay ~= string.sub(uservariables_lastupdate['weekend'],0,10) ) then
	if(self:weekend()) then 
		commandArray['Variable:weekend'] ='1'
	else
		commandArray['Variable:weekend'] ='0'
	end
end

end

function Day:initSaison()
	time=os.time()
	isDay=os.date('%m-%d',time)
	if( isDay == "12-21" ) then
		commandArray['Variable:saison'] ='Hiver'
	end
	if( isDay == "09-21" ) then
		commandArray['Variable:saison'] ='Automne'
	end
	if( isDay == "03-21" ) then
		commandArray['Variable:saison'] ='Printemps'
	end
	if( isDay == "06-21" ) then
		commandArray['Variable:saison'] ='Ete'
	end

end

function Day:initJour()
	commandArray['Variable:jour'] = self:getJourSemaine()
end

-- Retourne le jour de la semaine (lundi...dimanche)

function Day:getJourSemaine()
  return self.getJourSemaineTab[tonumber(os.date("%w"))]
end

-- Retourne le jour de Pâques au format epoch
-- annee : année (Integer) dont on désire connaître le jour de Pâques (ex : 2014)
-- La fonction n'effectue le calcul que si l'année a changée depuis son dernier appel
getJourPaquesAnnee=0      -- Variable globale (année du dernier calcul) pour ne pas recalculer le jour de Pâques à chaque appel
getJourPaquesEpochPaque=0 -- Variable globale (jour de Pâques au format epoch) pour ne pas recalculer le jour de Pâques à chaque appel
function Day:getJourPaques(annee)
  if(getJourPaquesAnnee~=annee or getJourPaquesEpochPaque==0) then
    local a=math.floor(annee/100)
    local b=math.fmod(annee,100)
    local c=math.floor((3*(a+25))/4)
    local d=math.fmod((3*(a+25)),4)
    local e=math.floor((8*(a+11))/25)
    local f=math.fmod((5*a+b),19)
    local g=math.fmod((19*f+c-e),30)
    local h=math.floor((f+11*g)/319)
    local j=math.floor((60*(5-d)+b)/4)
    local k=math.fmod((60*(5-d)+b),4)
    local m=math.fmod((2*j-k-g+h),7)
    local n=math.floor((g-h+m+114)/31)
    local p=math.fmod((g-h+m+114),31)
    local jour=p+1
    local mois=n
    getJourPaquesAnnee=annee
    getJourPaquesEpochPaque=os.time{year=annee,month=mois,day=jour,hour=12,min=0}
  end
  return getJourPaquesEpochPaque
end

-- Retourne true si le jour courant est un jour férié
-- Le calcul des jours férié n'est fait qu'un fois par an (ou si la Vera reboot)
jourFerieAnnee=0  -- Variable globale (année du dernier calcul) pour ne pas recalculer le tableau à chaque appel
jourFerieTab = {} -- Variable globale (tableau des jours fériés) pour ne pas recalculer le tableau à chaque appel
function Day:jourFerie()
  local today=os.date("%m-%d")
  local annee=tonumber(os.date("%Y"))
  if(annee~=jourFerieAnnee) then
    jourFerieAnnee=annee
    -- Dates fixes
    jourFerieTab["01-01"] = true -- 1er janvier
    jourFerieTab["05-01"] = true -- Fête du travail
    jourFerieTab["05-08"] = true -- Victoire des alliés
    jourFerieTab["07-14"] = true -- Fête nationale
    jourFerieTab["08-15"] = true -- Assomption
    jourFerieTab["11-01"] = true -- Toussaint
    jourFerieTab["11-11"] = true -- Armistice
    jourFerieTab["12-25"] = true -- Noël
    -- Dates variables
    local epochPaques=self:getJourPaques(annee)
    jourFerieTab[os.date("%m-%d",epochPaques)] = true             -- Pâques
    jourFerieTab[os.date("%m-%d",epochPaques+24*60*60)] = true    -- Lundi de Pâques = Pâques + 1 jour
    jourFerieTab[os.date("%m-%d",epochPaques+24*60*60*39)] = true -- Ascension = Pâques + 39 jours
    jourFerieTab[os.date("%m-%d",epochPaques+24*60*60*49)] = true -- Pentecôte = Ascension + 49 jours
  end
  return jourFerieTab[today] -- (nldr : Both nil and false make a condition false)
end

--------------------------------------------------------------------------------
-- Saint du Jour
--
--------------------------------------------------------------------------------
local sainjour = {}
sainjour["01:01"]= "jour de l An";
sainjour["02:01"]= "St Basile le Grand";
sainjour["03:01"]= "Ste Genevieve";
sainjour["04:01"]= "St Odilon";
sainjour["05:01"]="St Edouard le Confesseur";
sainjour["06:01"]="St Andre Corsini";
sainjour["07:01"]="St Raymond de Penyafort";
sainjour["08:01"]="St Lucien";
sainjour["09:01"]="Ste Alix de Ch.";
sainjour["10:01"]="St Guillaume de Bourges";
sainjour["11:01"]="St Paulin d Aquilee";
sainjour["12:01"]="Ste Tatiana";
sainjour["13:01"]="Ste Yvette";
sainjour["14:01"]="Ste Nina";
sainjour["15:01"]="St Remi";
sainjour["16:01"]="St Marcel";
sainjour["17:01"]="Ste Roseline";
sainjour["18:01"]="Ste Prisca";
sainjour["19:01"]="St Marius";
sainjour["20:01"]="St Sebastien";
sainjour["21:01"]="Ste Agnes";
sainjour["22:01"]="St Vincent";
sainjour["23:01"]="St Barnard";
sainjour["24:01"]="St Francois de Sales";
sainjour["25:01"]="la Conversion de St Paul";
sainjour["26:01"]="Ste Paule";
sainjour["27:01"]="Ste Angele Merici";
sainjour["28:01"]="St Thomas d Aquin";
sainjour["29:01"]="St Gildas le Sage";
sainjour["30:01"]="Ste Martine";
sainjour["31:01"]="Ste Marcelle";
sainjour["01:02"]="Ste Ella";
sainjour["02:02"]="St Theophane V.";
sainjour["03:02"]="St Blaise";
sainjour["04:02"]="Ste Veronique";
sainjour["05:02"]="Ste Agathe";
sainjour["06:02"]="St Gaston";
sainjour["07:02"]="Ste Eugenie Smet";
sainjour["08:02"]="Ste Jacqueline";
sainjour["09:02"]="Ste Apolline";
sainjour["10:02"]="St Arnaud";
sainjour["11:02"]="St Severin";
sainjour["12:02"]="St Felix d Abilene";
sainjour["13:02"]="Ste Beatrice";
sainjour["14:02"]="St Valentin";
sainjour["15:02"]="St Claude de la Colombiere";
sainjour["16:02"]="Ste Julienne";
sainjour["17:02"]="St Alexis Falconieri";
sainjour["18:02"]="Ste Bernadette";
sainjour["19:02"]="St Gabin";
sainjour["20:02"]="Ste Aimee";
sainjour["21:02"]="St Damien";
sainjour["22:02"]="Ste Isabelle";
sainjour["23:02"]="St Lazare";
sainjour["24:02"]="St Modeste";
sainjour["25:02"]="St Romeo";
sainjour["26:02"]="St Nestor";
sainjour["27:02"]="Ste Honorine";
sainjour["28:02"]="St Romain";
sainjour["29:02"]="St Auguste Chapdelaine";
sainjour["01:03"]="St Aubin";
sainjour["02:03"]="St Charles le Bon";
sainjour["03:03"]="St Gwenole";
sainjour["04:03"]="St Casimir";
sainjour["05:03"]="St Olive";
sainjour["06:03"]="Ste Colette";
sainjour["07:03"]="Ste Felicite";
sainjour["08:03"]="St Jean de Dieu";
sainjour["09:03"]="Ste Francoise Romaine";
sainjour["10:03"]="St Vivien";
sainjour["11:03"]="Ste Rosine";
sainjour["12:03"]="Ste Justine";
sainjour["13:03"]="St Rodrigue";
sainjour["14:03"]="Ste Mathilde";
sainjour["15:03"]="Ste Louise de Marillac";
sainjour["16:03"]="Ste Benedicte";
sainjour["17:03"]="St Patrick";
sainjour["18:03"]="St Cyrille de Jerusalem";
sainjour["19:03"]="St Joseph";
sainjour["20:03"]="St Herbert";
sainjour["21:03"]="Ste Clemence";
sainjour["22:03"]="Ste Lea";
sainjour["23:03"]="St Victorien";
sainjour["24:03"]="Ste Catherine de Suede";
sainjour["25:03"]="St Humbert";
sainjour["26:03"]="Ste Larissa";
sainjour["27:03"]="St Habib";
sainjour["28:03"]="St Gontran";
sainjour["29:03"]="Ste Gwladys";
sainjour["30:03"]="St Amedee de Savoie";
sainjour["31:03"]="St Benjamin";
sainjour["01:04"]="St Hugues de Grenoble";
sainjour["02:04"]="Ste Sandrine";
sainjour["03:04"]="St Richard";
sainjour["04:04"]="St Isidore de Seville";
sainjour["05:04"]="Ste Irene";
sainjour["06:04"]="St Marcellin";
sainjour["07:04"]="St Jean-Baptiste de la Salle";
sainjour["08:04"]="Ste Julie Billard";
sainjour["09:04"]="St Gautier";
sainjour["10:04"]="St Fulbert";
sainjour["11:04"]="St Stanislas";
sainjour["12:04"]="St Jules 1er";
sainjour["13:04"]="Ste Ida";
sainjour["14:04"]="St Maxime";
sainjour["15:04"]="St Paterne de Vannes";
sainjour["16:04"]="St BenoîLabre";
sainjour["17:04"]="St Etienne Harding";
sainjour["18:04"]="St Parfait";
sainjour["19:04"]="Ste Emma";
sainjour["20:04"]="Ste Odette";
sainjour["21:04"]="St Anselme";
sainjour["22:04"]="St Alexandre";
sainjour["23:04"]="St Georges";
sainjour["24:04"]="St Fidele de Sigmaringen";
sainjour["25:04"]="St Marc";
sainjour["26:04"]="Ste Alida";
sainjour["27:04"]="Ste Zita";
sainjour["28:04"]="Ste Valerie";
sainjour["29:04"]="Ste Catherine de Sienne";
sainjour["30:04"]="St Robert";
sainjour["01:05"]="St Joseph Artisan";
sainjour["02:05"]="St Boris";
sainjour["03:05"]="Sts Philippe et Jacques le Mineur";
sainjour["04:05"]="St Sylvain de Gaza";
sainjour["05:05"]="Ste Judith";
sainjour["06:05"]="Ste Prudence";
sainjour["07:05"]="Ste Gisele";
sainjour["08:05"]="St Desire";
sainjour["09:05"]="Ste Pacome";
sainjour["10:05"]="Ste Solange";
sainjour["11:05"]="Ste Estelle";
sainjour["12:05"]="Sts Achille et Neree";
sainjour["13:05"]="Ste Rolande";
sainjour["14:05"]="St Matthias";
sainjour["15:05"]="Ste Denise";
sainjour["16:05"]="St Honore";
sainjour["17:05"]="St Pascal Baylon";
sainjour["18:05"]="St Eric";
sainjour["19:05"]="St Yves Helory";
sainjour["20:05"]="St Bernardin";
sainjour["21:05"]="St Constantin";
sainjour["22:05"]="St Emile";
sainjour["23:05"]="St Didier de Vienne";
sainjour["24:05"]="St Donatien";
sainjour["25:05"]="Ste Sophie";
sainjour["26:05"]="St Berenger";
sainjour["27:05"]="St Augustin de Canterbury";
sainjour["28:05"]="St Germain de Paris";
sainjour["29:05"]="St Aymard";
sainjour["30:05"]="St Ferdinand";
sainjour["31:05"]="Ste Perrine";
sainjour["01:06"]="St Justin";
sainjour["02:06"]="Ste Blandine";
sainjour["03:06"]="St Charles Lwanga";
sainjour["04:06"]="Ste Clotilde";
sainjour["05:06"]="St Igor";
sainjour["06:06"]="St Norbert";
sainjour["07:06"]="St Gilbert de Neuffontaines";
sainjour["08:06"]="St Medard";
sainjour["09:06"]="Ste Diane";
sainjour["10:06"]="St Landry";
sainjour["11:06"]="St Barnabe";
sainjour["12:06"]="St Guy";
sainjour["13:06"]="St Antoine de Padoue";
sainjour["14:06"]="St Elisee";
sainjour["15:06"]="Ste Germaine cousin";
sainjour["16:06"]="St Jean-Francois Regis";
sainjour["17:06"]="St Herve";
sainjour["18:06"]="St Leonce";
sainjour["19:06"]="St Romuald";
sainjour["20:06"]="St Silvere";
sainjour["21:06"]="St Rodolphe";
sainjour["22:06"]="St Alban";
sainjour["23:06"]="Ste Audrey";
sainjour["24:06"]="St Jean-Baptiste";
sainjour["25:06"]="St Prosper";
sainjour["26:06"]="St Anthelme";
sainjour["27:06"]="St Fernand";
sainjour["28:06"]="St Irenee";
sainjour["29:06"]="Sts Pierre et Paul";
sainjour["30:06"]="St Martial";
sainjour["01:07"]="St Thierry";
sainjour["02:07"]="St Martinien";
sainjour["03:07"]="St Thomas";
sainjour["04:07"]="St Florent";
sainjour["05:07"]="St Antoine-Marie Zaccharia";
sainjour["06:07"]="Ste Marietta Goretti";
sainjour["07:07"]="St Raoul Milner";
sainjour["08:07"]="St Thibaud";
sainjour["09:07"]="Ste Amandine";
sainjour["10:07"]="St Ulric de Zell";
sainjour["11:07"]="St Benoit";
sainjour["12:07"]="St Olivier";
sainjour["13:07"]="St Henri et de Joel";
sainjour["14:07"]="St Camille de Lellis";
sainjour["15:07"]="St Donald";
sainjour["16:07"]="Ste Elvire";
sainjour["17:07"]="Ste Charlotte";
sainjour["18:07"]="St Frederic";
sainjour["19:07"]="St Arsene";
sainjour["20:07"]="Ste Marina";
sainjour["21:07"]="St Victor";
sainjour["22:07"]="Ste Marie-Madeleine";
sainjour["23:07"]="Ste Brigitte de Suede";
sainjour["24:07"]="Ste Christine";
sainjour["25:07"]="St Jacques le Majeur";
sainjour["26:07"]="Ste Anne";
sainjour["27:07"]="Sts Aurele et Nathalie de Cordoue";
sainjour["28:07"]="St Samson";
sainjour["29:07"]="Ste Marthe";
sainjour["30:07"]="Ste Juliette";
sainjour["31:07"]="St Ignace de Loyola";
sainjour["01:08"]="St Alphonse-Marie de Liguori";
sainjour["02:08"]="St Pierre-Julien Eymard";
sainjour["03:08"]="Ste Lydie";
sainjour["04:08"]="St Jean-Marie Vianney";
sainjour["05:08"]="St Abel";
sainjour["06:08"]="St Octavien";
sainjour["07:08"]="St Gaetan";
sainjour["08:08"]="St Dominique";
sainjour["09:08"]="St Amour";
sainjour["10:08"]="St Laurent";
sainjour["11:08"]="Ste Claire d Assise";
sainjour["12:08"]="Ste Clarisse";
sainjour["13:08"]="St Hippolyte";
sainjour["14:08"]="St Evrard";
sainjour["15:08"]="Ste Marie";
sainjour["16:08"]="St Armel";
sainjour["17:08"]="St Hyacinthe de Cracovie";
sainjour["18:08"]="Ste Helene";
sainjour["19:08"]="St Jean-Eudes";
sainjour["20:08"]="St Bernard";
sainjour["21:08"]="St Christophe";
sainjour["22:08"]="St Fabrice";
sainjour["23:08"]="Ste Rose de Lima";
sainjour["24:08"]="St Barthelemy";
sainjour["25:08"]="St Louis  Roi de France";
sainjour["26:08"]="Ste Natacha";
sainjour["27:08"]="Ste Monique";
sainjour["28:08"]="St Augustin d Hippone";
sainjour["29:08"]="Ste Sabine";
sainjour["30:08"]="St Fiacre";
sainjour["31:08"]="St Aristide";
sainjour["01:09"]="St Gilles";
sainjour["02:09"]="Ste Ingrid";
sainjour["03:09"]="St Gregoire le Grand";
sainjour["04:09"]="Ste Rosalie de Palerme";
sainjour["05:09"]="Ste Raissa";
sainjour["06:09"]="St Bertrand";
sainjour["07:09"]="Ste Reine";
sainjour["08:09"]="St Adrien";
sainjour["09:09"]="St Alain de la Roche";
sainjour["10:09"]="Ste Ines Takeya";
sainjour["11:09"]="St Adelphe";
sainjour["12:09"]="St Apollinaire";
sainjour["13:09"]="St Aime";
sainjour["14:09"]="la Croix Glorieuse";
sainjour["15:09"]="St Roland";
sainjour["16:09"]="Ste Edith";
sainjour["17:09"]="St Renaud";
sainjour["18:09"]="Ste Nadege";
sainjour["19:09"]="Ste Emilie de Rodat";
sainjour["20:09"]="St Davy";
sainjour["21:09"]="St Matthieu";
sainjour["22:09"]="St Maurice d Agaune";
sainjour["23:09"]="St Constant";
sainjour["24:09"]="Ste Thecle";
sainjour["25:09"]="St Hermann";
sainjour["26:09"]="Sts Come et Damien";
sainjour["27:09"]="St Vincent de Paul";
sainjour["28:09"]="St Venceslas";
sainjour["29:09"]="St Michel";
sainjour["30:09"]="St Jerome";
sainjour["01:10"]="Ste Therese de lisieux";
sainjour["02:10"]="St Leger";
sainjour["03:10"]="St Gerard Majella";
sainjour["04:10"]="St Francois d Assise";
sainjour["05:10"]="Ste Fleur";
sainjour["06:10"]="St Bruno";
sainjour["07:10"]="St Serge";
sainjour["08:10"]="Ste Pelagie";
sainjour["09:10"]="St Denis";
sainjour["10:10"]="St Ghislain";
sainjour["11:10"]="St Firmin";
sainjour["12:10"]="St Wilfrid";
sainjour["13:10"]="St Geraud d Aurillac";
sainjour["14:10"]="St Juste";
sainjour["15:10"]="Ste Therese d Avila";
sainjour["16:10"]="Ste Edwige";
sainjour["17:10"]="St Baudouin";
sainjour["18:10"]="St Luc";
sainjour["19:10"]="St Rene Goupil";
sainjour["20:10"]="Sts Vital et Adeline";
sainjour["21:10"]="Ste Celine";
sainjour["22:10"]="Ste Elodie";
sainjour["23:10"]="St Jean de Capistran";
sainjour["24:10"]="St Florentin";
sainjour["25:10"]="Sts Crepin et Doria";
sainjour["26:10"]="St Dimitri";
sainjour["27:10"]="Ste Emeline";
sainjour["28:10"]="Sts Simon et Jude";
sainjour["29:10"]="St Narcisse";
sainjour["30:10"]="Ste Bienvenue";
sainjour["31:10"]="St Quentin";
sainjour["01:11"]="Tous les Sts";
sainjour["02:11"]="Defunts";
sainjour["03:11"]="St Hubert";
sainjour["04:11"]="St Charles Borromee";
sainjour["05:11"]="Ste Sylvie";
sainjour["06:11"]="Ste Bertille de Chelles";
sainjour["07:11"]="Ste Carine";
sainjour["08:11"]="St Geoffroy";
sainjour["09:11"]="St Theodore";
sainjour["10:11"]="St Leon le Grand";
sainjour["11:11"]="St Martin";
sainjour["12:11"]="St Christian";
sainjour["13:11"]="St Brice";
sainjour["14:11"]="St Sidoine";
sainjour["15:11"]="St Albert le Grand";
sainjour["16:11"]="Ste Marguerite d Ecosse";
sainjour["17:11"]="Ste Elisabeth de Hongrie";
sainjour["18:11"]="Ste Aude";
sainjour["19:11"]="St Tanguy de Bretagne";
sainjour["20:11"]="St Edmond d Angleterre";
sainjour["21:11"]="St Albert";
sainjour["22:11"]="Ste Cecile";
sainjour["23:11"]="St Clement";
sainjour["24:11"]="Ste Flora";
sainjour["25:11"]="Ste Catherine d Alexandrie";
sainjour["26:11"]="Ste Delphine";
sainjour["27:11"]="St Severin de Paris";
sainjour["28:11"]="St Jacques de la Marche";
sainjour["29:11"]="St Saturnin de Toulouse";
sainjour["30:11"]="St Andre";
sainjour["01:12"]="Ste Florence";
sainjour["02:12"]="Ste Viviane";
sainjour["03:12"]="St Francois-Xavier";
sainjour["04:12"]="Ste Barbara";
sainjour["05:12"]="St Gerald de Braga";
sainjour["06:12"]="St Nicolas de Myre";
sainjour["07:12"]="St Ambroise de Milan";
sainjour["08:12"]="Ste Elfie";
sainjour["09:12"]="St Pierre Fourier";
sainjour["10:12"]="St Romaric";
sainjour["11:12"]="St Daniel";
sainjour["12:12"]="Ste Jeanne-Francoise de Chantal";
sainjour["13:12"]="Ste Lucie";
sainjour["14:12"]="Ste Odile";
sainjour["15:12"]="Ste Ninon";
sainjour["16:12"]="Ste Alice";
sainjour["17:12"]="St Gael";
sainjour["18:12"]="St Gatien";
sainjour["19:12"]="St Urbain";
sainjour["20:12"]="St Theophile";
sainjour["21:12"]="St Pierre Canisius";
sainjour["22:12"]="Ste Francoise-Xaviere Cabrini";
sainjour["23:12"]="St Armand";
sainjour["24:12"]="Ste Adele";
sainjour["25:12"]="Noel";
sainjour["26:12"]="St Etienne";
sainjour["27:12"]="St Jean l evangeliste";
sainjour["28:12"]="Sts Innocents";
sainjour["29:12"]="St David";
sainjour["30:12"]="St Roger";
sainjour["31:12"]="St Sylvestre";

function Day:initSaintJour()
	local today=os.date("%d:%m")
	commandArray['Variable:saint'] = sainjour[tostring(today)]
end
