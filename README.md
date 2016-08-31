# ca-scratch-generator
Builds a Docker image based on `scratch` with the up-to-date version of the CA certificates bundled in.

## Normal generation procedure

- Build the Docker image unsing an intermediate container:
```
    make
```
- Manually check the changes in the `ca-bundle.crt` file (that's the purpose for it to be included in the repository).

- Push the image to the repository (this will create the new tag marked with the today's date and update the `latest` tag):
```
    make push
```
## Extended procedures

- To update the `mk-ca-bundle.pl` file use (**WARNING!** Don't trust blindly to the source of this file, always check it by yourself):
```
    make update-mk-ca-bundle.pl
``` 
- To generate `ca-bundle.crt` on the local machine (without the intermediate container — you would need to have `perl` and `LWP::UserAgent` installed):
```
    make ca-bundle.crt
```
- To generate the image from existing `ca-bundle.crt`:
```
    make image
```
