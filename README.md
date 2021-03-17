# Packer image containing Nomad and Consul ready to be clustered

```shell
PKR_VAR_project_id=<your GCP project> packer build -var-file packer.auto.pkrvars.hcl packer.pkr.hcl
```

This will build an image based on Ubuntu, that runs Nomad using Systemd.
The version of the source image and Nomad can be set in the `packer.auto.pkrvars.hcl` file.

To change additional things in the image, edit the `bootstrap.sh` script.
