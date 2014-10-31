<?php
  header('Content-Type: text/xml; charset=UTF-8');
  
  require_once( dirname( __FILE__ ) . '/class/TransmissionRPC.class.php' );
  
  
   function print_r_xml($arr,$first=true) {
     $output = "";
     if ($first) $output .= "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<data>\n";
     foreach($arr as $key => $val) {
      if (is_numeric($key)) $key = "arr_".$key; // <0 is not allowed
      switch (gettype($val)) {
        case "array":
         $output .= "<".htmlspecialchars($key).">".
           print_r_xml($val,false)."</".htmlspecialchars($key).">\n"; break;
        case "boolean":
         $output .= "<".htmlspecialchars($key).">".
           "</".htmlspecialchars($key).">\n"; break;
        case "integer":
         $output .= "<".htmlspecialchars($key).">".
           htmlspecialchars($val)."</".htmlspecialchars($key).">\n"; break;
        case "double":
         $output .= "<".htmlspecialchars($key).">".
           htmlspecialchars($val)."</".htmlspecialchars($key).">\n"; break;
        case "string":
         $output .= "<".htmlspecialchars($key).">".
           htmlspecialchars($val)."</".htmlspecialchars($key).">\n"; break;
        default:
         $output .= "<".htmlspecialchars($key).">".
           "</".htmlspecialchars($key).">\n"; break;
      }
     }
     if ($first) $output .= "</data>\n";
     return $output;
   }
    
    
$rpc = new TransmissionRPC();
$rpc->username = 'username';
$rpc->password = 'password';
 
try
{
  $rpc->return_as_array = true;
   $result = $rpc->get();
  
      $data = array_reverse( $result['arguments']['torrents'] );
      echo print_r_xml($data);
  
  $rpc->return_as_array = false;
  
} catch (Exception $e) {
  die('[ERROR] ' . $e->getMessage() . PHP_EOL);
}
 
?>