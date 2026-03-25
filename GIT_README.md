# Guia de Uso

---

* **origin** → seu repositório (onde você dá *push*)
* **upstream** → repositório original (do professor, de onde você dá *pull*)

> upstream = fonte de atualizações

---

O repo do professor é mantido como referência e sincroniza quando quiser.

1. Adiciona o repo do professor como *upstream* no seu repo principal:

```bash
git remote add upstream <url-do-professor>
```

2. Quando ele atualizar:

```bash
git pull upstream main
```

ou 

```bash
git fetch upstream
git merge upstream/main
```

---

### Fluxo 

```bash
professor (upstream) → você puxa → seu repo (origin) → você envia
```

---

* Você quer acompanhar atualizações automaticamente
* Quer manter histórico e estrutura próximos do original
* Não pretende modificar drasticamente os arquivos

---

> upstream = “de onde vem o conteúdo novo”
> origin = “onde está o meu trabalho”

---