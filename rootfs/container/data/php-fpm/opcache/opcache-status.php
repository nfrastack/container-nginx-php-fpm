<?php
  $status = opcache_get_status(false);
  echo json_encode($status);
  echo "\n";
?>