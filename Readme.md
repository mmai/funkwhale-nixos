# Funkwhale on NixOS

1. Installation de l'outil de déploiement NixOps

```bash
nixenv -i nixops
```

Test sur virtualbox : virtualbox doit être installé. 

Note that for this to work the vboxnet0 network has to exist - you can add it in the VirtualBox general settings under Networks - Host-only Networks if necessary.

2. Initialisation du déploiement (contient l'état du déploiement associé)

```bash
nixops create ./deploy/logical.nix ./deploy/physical/virtualbox.nix -d funkwhale
```

Pour obtenir la liste des déploiements configurés :
```
nixpos list
```

Déployer :
```
nixops deploy -d funkwhale
```

Si erreur `Exception: unable to activate new configuration` lié à _virtualbox.service_ : 

```
nixops deploy --force-reboot -d funkwhale
```

Info sur le déploiement:
```
nixops info -d funkwhale
```

Se connecter en ssh sur la machine :
```
nixops ssh -d funkwhale funkwhale
```

Statut d'une machine virtuelle :
```
nixops check -d funkwhale
```

Détruire une machine virtuelle :
```
nixops destroy -d funkwhale
```

