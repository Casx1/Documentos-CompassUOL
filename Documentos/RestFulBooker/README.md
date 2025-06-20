# Automação da API - Restful Booker

Este repositório contém a automação de testes da API [Restful-Booker](https://restful-booker.herokuapp.com/apidoc/index.html), utilizando Robot Framework. O objetivo é garantir a validação de todos os endpoints fornecidos, com uma estrutura modular, reutilizável e de fácil manutenção.

##  Tecnologias Utilizadas

- [Robot Framework](https://robotframework.org/)
- [RequestsLibrary](https://marketsquare.github.io/robotframework-requests/)
- Python 3.x

##  Estrutura do Projeto

```
RestFulBooker/
├── keywords/
│   ├── _base.robot                # Setup e utilitários comuns
│   ├── Auth.robot                 # Login e token de autenticação
│   ├── CreateBooking.robot        # Criação de reservas
│   ├── DeleteBooking.robot        # Exclusão de reservas
│   ├── GetBooking.robot           # Obtenção de detalhes da reserva
│   ├── GetBookingIds.robot        # Listagem de IDs de reservas
│   ├── PartialUpdateBooking.robot # Atualização parcial (PATCH)
│   ├── Ping.robot                 # Verificação de disponibilidade (Health Check)
│   └── UpdateBooking.robot        # Atualização completa da reserva (PUT)
├── support/
│   └── common
│       └── common_resources.robot # Centralização de dependências do projeto
├── tests/
│   ├── tests_auth.robot           # Casos de testes rota auth
│   ├── tests_booking.robot        # Casos de testes rota booking
│   ├── tests_ping.robot           # Casos de testes rota ping
│   └── tests_all.robot            # Casos de testes organizados por fluxo
├── _base.robot                    # Dependências e variáveis do projeto
├── requirements.txt               # Dependências do projeto
```

##  Executando os Testes

### 1. Clonar o repositório

```bash
git clone https://github.com/Casx1/Documentos-CompassUOL.git
cd Documentos-CompassUOL/Documentos/RestFulBooker
```

### 2. Criar e ativar o ambiente virtual

```bash
python -m venv .venv
source .venv/bin/activate  # No Windows: .venv\Scripts\activate
```

### 3. Instalar as dependências

```bash
pip install -r requirements.txt
```

### 4. Executar os testes

```bash
robot tests/tests_all.robot
```

##  Observações

- Os arquivos da pasta `keywords/` foram separados por endpoint para maior organização e reutilização.
- O arquivo `_base.robot` contém configurações reutilizáveis (URL base, headers, etc).
- O projeto foi construído para facilitar manutenções e extensões futuras.

