# NGINX Proxy via Fleet para GitHub Pages

Este diretório contém a configuração completa para o Rancher Fleet que faz o **Ingress Controller NGINX** atuar como **proxy reverso** para um site hospedado no **GitHub Pages**, servindo sob o domínio institucional `https://daniel.ci.ufpb.br`.

---

## 🚀 Objetivo

Permitir que o domínio `daniel.ci.ufpb.br` sirva o conteúdo de:
> https://dcruzf.github.io/dcruzf

Usando um **proxy reverso HTTPS** no Kubernetes, gerenciado via **Fleet e cert-manager**.

---

## 📂 Estrutura dos arquivos

| Arquivo | Função |
|----------|--------|
| `fleet.yaml` | Informa ao Fleet que deve aplicar esta pasta. |
| `namespace.yaml` | Cria o namespace `nginx-proxy`. |
| `cluster-issuer.yaml` | Cria um emissor ACME (Let's Encrypt) para certificados TLS. |
| `ingress.yaml` | Define o Ingress e o Service que fazem o proxy reverso. |
| `kustomization.yaml` | Lista os manifests aplicados pelo Kustomize. |
| `README.md` | Este guia de explicação. |

---

## 🔧 Detalhes técnicos

### 1. Service externo

O arquivo `ingress.yaml` define um **Service ExternalName**:
```yaml
externalName: dcruzf.github.io
```
Isso instrui o Kubernetes a tratar o domínio do GitHub Pages como backend remoto.

---

### 2. Proxy reverso via NGINX

O **Ingress** intercepta requisições para `daniel.ci.ufpb.br` e as encaminha para `https://dcruzf.github.io`, mantendo o caminho (`/`) e redirecionando cabeçalhos corretamente:

```yaml
nginx.ingress.kubernetes.io/configuration-snippet: |
  proxy_set_header Host dcruzf.github.io;
```

---

### 3. TLS automático

O certificado TLS é obtido automaticamente via **cert-manager + Let's Encrypt**, configurado em:

```yaml
cert-manager.io/cluster-issuer: letsencrypt-production
```

---

## ✅ Aplicação via Fleet

1. Adicione este repositório ao Rancher Fleet.
2. Aguarde o bundle `nginx-proxy` ser sincronizado.
3. Após o deploy, acesse:

> https://daniel.ci.ufpb.br

O conteúdo deve corresponder ao site do GitHub Pages `https://dcruzf.github.io/dcruzf`.

---

## 🧠 Dica

Se desejar trocar o domínio ou repositório GitHub, basta alterar:

- `externalName`  
- `host` (em `rules` e `tls`)

E re-sincronizar o bundle no Fleet.
