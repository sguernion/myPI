
package.path = package.path..";/home/pi/domoticz/scripts/lua/modules/?.lua"
require 'properties'

Day = {}
Day.__index = Day

function Day.create()
   local mrt = {}             -- our new object
   setmetatable(mrt,Day)  -- make handle lookup
   mrt.jourChomeToday="NULL" -- Variable globale (date du dernier calcul) pour ne pas recalculer le résultat à chaque appel
   mrt.josdJourChomeReturn=false -- Variable globale (résulat du dernier calcul) pour ne pas recalculer le résultat à chaque appel
   mrt.veilleJourChomeReturn=false
   mrt.getJourSemaineTab={[0]="dimanche",[1]="lundi",[2]="mardi",[3]="mercredi",[4]="jeudi",[5]="vendredi",[6]="samedi"}
   return mrt
end

-- Retourne true si le jour courant est un jour chômé (passé à la maison)
-- Le calcul effectif n'est fait qu'une fois par jour (ou si la Vera reboot)

function Day:jourChome()
  local today=os.date("%Y-%m-%d")
  if(today~=self.jourChomeToday) then -- Faut-il refaire le calcul ?
    local jour=self:getJourSemaine()
    self.jourChomeToday=today
    self.josdJourChomeReturn=(jour=="samedi" or jour=="dimanche" or self:jourFerie())
  end
  return self.josdJourChomeReturn
end

function Day:veilleJourChome()
  local today=os.date("%Y-%m-%d")
  if(today~=self.jourChomeToday) then -- Faut-il refaire le calcul ?
    local jour=self:getJourSemaine()
    self.jourChomeToday=today
    self.veilleJourChomeReturn=(jour=="vendredi" or jour=="samedi")
  end
  return self.veilleJourChomeReturn
end

-- Retourne le jour de la semaine (lundi...dimanche)

function Day:getJourSemaine()
  return self.getJourSemaineTab[tonumber(os.date("%w"))]
end

-- Retourne le jour de Pâques au format epoch
-- annee : année (Integer) dont on désire connaître le jour de Pâques (ex : 2014)
-- La fonction n'effectue le calcul que si l'année a changée depuis son dernier appel
josdGetJourPaquesAnnee=0      -- Variable globale (année du dernier calcul) pour ne pas recalculer le jour de Pâques à chaque appel
josdGetJourPaquesEpochPaque=0 -- Variable globale (jour de Pâques au format epoch) pour ne pas recalculer le jour de Pâques à chaque appel
function Day:getJourPaques(annee)
  if(josdGetJourPaquesAnnee~=annee or josdGetJourPaquesEpochPaque==0) then
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
    josdGetJourPaquesAnnee=annee
    josdGetJourPaquesEpochPaque=os.time{year=annee,month=mois,day=jour,hour=12,min=0}
  end
  return josdGetJourPaquesEpochPaque
end

-- Retourne true si le jour courant est un jour férié
-- Le calcul des jours férié n'est fait qu'un fois par an (ou si la Vera reboot)
josdJourFerieAnnee=0  -- Variable globale (année du dernier calcul) pour ne pas recalculer le tableau à chaque appel
josdJourFerieTab = {} -- Variable globale (tableau des jours fériés) pour ne pas recalculer le tableau à chaque appel
function Day:jourFerie()
  local today=os.date("%m-%d")
  local annee=tonumber(os.date("%Y"))
  if(annee~=josdJourFerieAnnee) then
    josdJourFerieAnnee=annee
    -- Dates fixes
    josdJourFerieTab["01-01"] = true -- 1er janvier
    josdJourFerieTab["05-01"] = true -- Fête du travail
    josdJourFerieTab["05-08"] = true -- Victoire des alliés
    josdJourFerieTab["07-14"] = true -- Fête nationale
    josdJourFerieTab["08-15"] = true -- Assomption
    josdJourFerieTab["11-01"] = true -- Toussaint
    josdJourFerieTab["11-11"] = true -- Armistice
    josdJourFerieTab["12-25"] = true -- Noël
    -- Dates variables
    local epochPaques=self:getJourPaques(annee)
    josdJourFerieTab[os.date("%m-%d",epochPaques)] = true             -- Pâques
    josdJourFerieTab[os.date("%m-%d",epochPaques+24*60*60)] = true    -- Lundi de Pâques = Pâques + 1 jour
    josdJourFerieTab[os.date("%m-%d",epochPaques+24*60*60*39)] = true -- Ascension = Pâques + 39 jours
    josdJourFerieTab[os.date("%m-%d",epochPaques+24*60*60*49)] = true -- Pentecôte = Ascension + 49 jours
  end
  return josdJourFerieTab[today] -- (nldr : Both nil and false make a condition false)
end

