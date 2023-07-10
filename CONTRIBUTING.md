## General
This project leverages [terraform-docs](https://terraform-docs.io/) to generate the documentation in the README.

A [pre-commit](https://pre-commit.com/) hook is used to ensure the documentation remains up-to-date. After cloning this project, run: 
```shell
$ pre-commit install
```
Now you can make a Terraform change, `git add` and `git commit`. The pre-commit hook will fail and reject your commit if the docs are not updated, but it will regenerate the Terraform docs, after which you can rerun `git add` and `git commit` to commit the code and doc changes together.  

To manually update the docs you can either run:
```shell
$ pre-commit run -a terraform-docs-go
```
or, if you have the `terraform-docs` binary installed, you can simply run
```
$ make
```