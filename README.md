# Script ChangeDNS

## Visão Geral

O ChangeDNS é um script esperto que facilita a configuração dos servidores DNS das suas interfaces de rede, seja no Windows ou no Linux (ainda em desenvolvimento). 
Com ele, você pode definir ou resetar as configurações de DNS de maneira bem simples e prática.

## Funcionalidades

- **Definir DNS**: Configure os servidores DNS primário e secundário para uma interface de rede específica.
- **Redefinir DNS**: Volte a configuração de DNS para automático em uma interface de rede.
- **Cross-Platform**: Funciona tanto no Windows (PowerShell) quanto no Linux (Bash).

## Como Usar

### Windows

#### Pré-requisitos

- PowerShell 5.1 ou superior
- Privilégios de administrador

#### Instalação

1. Baixe o script `changedns.ps1`.
2. Salve-o em um diretório, por exemplo, `C:\Scripts`.
3. Adicione esse diretório ao PATH do sistema:
    - Abra o Painel de Controle e vá para **Sistema e Segurança > Sistema > Configurações avançadas do sistema**.
    - Clique em **Variáveis de Ambiente**.
    - Na seção **Variáveis do Sistema**, encontre a variável `Path` e clique em **Editar**.
    - Adicione `C:\Scripts` à lista e clique em **OK**.

#### Uso

```powershell
.\changedns.ps1 -Action Set -Interface "Ethernet" -PrimaryDNS "8.8.8.8" -SecondaryDNS "8.8.4.4"
.\changedns.ps1 -Action Reset -Interface "Ethernet"
```
