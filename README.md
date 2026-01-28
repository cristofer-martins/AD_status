# 🔓 AD Status Realtime - GLPI Plugin

Este plugin adiciona uma aba no perfil do usuário do GLPI que consulta o **Active Directory (AD)** em tempo real.

Diferente da sincronização padrão do GLPI (que ocorre apenas no login ou via cron), este plugin mostra o status exato **no momento em que você abre a aba**, permitindo identificar contas bloqueadas, desativadas ou com senha expirada instantaneamente.

## 🚀 Funcionalidades

* **Status em Tempo Real:** Consulta direta via LDAP (sem cache de banco).
* **Indicadores Visuais:**
    * ✅ **Ativo:** Conta funcional.
    * 🔒 **Bloqueado (Lockout):** Excesso de tentativas de senha.
    * ⛔ **Desativado:** Conta desabilitada administrativamente.
* **Diagnóstico:** Mostra o motivo do status (ex: "Conta desabilitada manualmente").
* **Último Login:** Converte o timestamp do Windows para data legível.
* **Alerta de Senha:** Avisa se a senha precisa ser trocada no próximo login (`pwdLastSet = 0`).
* **Híbrido (GLPI 10 & 11):** Funciona no GLPI 10 (Legacy) e já está pronto para o GLPI 11 (Twig Templates).

---

## 📦 Instalação Rápida (Recomendado)

Rode o comando abaixo no terminal do seu servidor GLPI.
O script detecta automaticamente sua versão do GLPI (10 ou 11) e baixa o pacote correto.

```bash
bash <(wget -qO- [https://raw.githubusercontent.com/cristofer-martins/AD_status/main/install.sh](https://raw.githubusercontent.com/cristofer-martins/AD_status/main/install.sh))
