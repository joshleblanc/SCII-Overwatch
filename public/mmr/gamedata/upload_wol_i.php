
<?php
    // Open serialized data
    $data = unserialize( file_get_contents( './gamecount_wol.txt' ) );
	$data = $data+1;
	    // Serialize & Save
    $file = fopen( './gamecount_wol.txt', 'w+' );
    fwrite( $file, serialize( $data ) );
    fclose( $file );
  $filename="data_wol_i.txt";
  $fileData=file_get_contents('php://input');
  $fileData=substr($fileData, 0, 500);
  $fhandle=fopen($filename, 'a+');
  fwrite($fhandle, $fileData);
  fclose($fhandle);
  echo("Done");

?>