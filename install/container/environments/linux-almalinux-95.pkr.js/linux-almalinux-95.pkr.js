{
  "variables": { },
  "builders": [
    {
      "type": "docker",
      "image": "tipibuild/tipi-almalinux-95:{{tipi_cli_local_version}}",
      "commit": true
    }
  ],
  "post-processors": [
    { 
      "type": "docker-tag",
      "repository": "linux",
      "tag": "latest"
    }
  ]
  ,"_tipi_version":"{{tipi_version_hash}}"


}