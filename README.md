# Local Environment Setup

Este projeto centraliza a infraestrutura local necessária para executar os microsserviços `customers-service` e `insurance-service`. Ele orquestra containers Docker para PostgreSQL, MongoDB, Redis, Kafka e as próprias aplicações Java.

## 🚀 Pré-requisitos e Ferramentas

Para participar do projeto e rodar o ambiente local, você precisará instalar as seguintes ferramentas:

*   **Java 21 (OpenJDK):** Pode ser instalado via [SDKMAN!](https://sdkman.io/) (Linux/macOS/WSL) ou [Scoop](https://scoop.sh/) (Windows).
*   **Docker e Docker Compose:** Essencial para rodar a infraestrutura (bancos, mensageria e serviços).
*   **IDE:** Recomendamos o **IntelliJ IDEA**, mas o **VS Code** também pode ser utilizado.
*   **DBeaver:** Para conectar e gerenciar o banco de dados PostgreSQL.
*   **MongoDB Atlas / MongoDB Compass:** Para conectar e gerenciar o banco de dados MongoDB.
*   **Redis Insight (Opcional):** Para visualização das chaves do Redis. Como alternativa, você pode usar o `redis-cli` diretamente de dentro do container do próprio Redis.

## 📦 Serviços e Portas

| Serviço                 | Porta Externa | Descrição                                  |
|:------------------------|:--------------|:-------------------------------------------|
| **customers-service**   | `8080`        | API de Clientes                            |
| **insurance-service**   | `8081`        | API de Seguros                             |
| **PostgreSQL**          | `5432`        | Banco de dados relacional                  |
| **MongoDB**             | `27017`       | Banco de dados NoSQL                       |
| **Redis**               | `6379`        | Banco de dados em memória (Cache)          |
| **Kafka**               | `9092`        | Broker de mensageria                       |
| **Schema Registry**     | `9091`        | Registro de schemas do Kafka               |
| **Kafka UI**            | `9090`        | Interface gráfica para gerenciar o Kafka   |

### 📂 Repositórios dos Serviços

⚠️ **Importante:** Para que o build funcione corretamente, todos os repositórios devem ser clonados no mesmo diretório pai. O script de subida espera encontrar as pastas dos projetos ao lado deste repositório (`local-env-setup`).

**Customers Service**

HTTPS:
```bash
git clone https://github.com/juninhos-unidos/customers-service.git
```

SSH:
```bash
git clone git@github.com:juninhos-unidos/customers-service.git
```

GitHub CLI:
```bash
gh repo clone juninhos-unidos/customers-service
```

**Insurance Service**

HTTPS:
```bash
git clone https://github.com/juninhos-unidos/insurance-service.git
```

SSH:
```bash
git clone git@github.com:juninhos-unidos/insurance-service.git
```

GitHub CLI:
```bash
gh repo clone juninhos-unidos/insurance-service
```

## 🛠️ Como Executar

O projeto inclui scripts utilitários para facilitar o gerenciamento do ambiente de acordo com o seu Sistema Operacional. 

*   **Linux / macOS / Windows com WSL:** Utilize o script `local-env-setup.sh`.
*   **Windows (CMD/PowerShell):** Utilize o script `local-env-setup.bat`.

### 🐧 Linux / macOS / WSL (`.sh`)

1.  **Dê permissão de execução ao script (primeira vez):**
    ```bash
    chmod +x local-env-setup.sh
    ```

2.  **Inicie o ambiente:**
    ```bash
    ./local-env-setup.sh up
    ```
    Isso irá construir as imagens e iniciar os containers em segundo plano.

    > ⚠️ **Atenção:** A primeira execução pode levar alguns minutos devido ao download das imagens Docker e builds do Gradle. Este tempo pode variar dependendo da sua conexão com a internet e desempenho da máquina.

3.  **Verifique o status:**
    ```bash
    ./local-env-setup.sh status
    ```

4.  **Pare o ambiente:**
    ```bash
    ./local-env-setup.sh stop
    ```

5.  **Remova o ambiente (containers e volumes):**
    ```bash
    ./local-env-setup.sh down
    ```

### 🪟 Windows (`.bat`)

O script `.bat` realiza uma tratativa automática dos finais de linha (`\r\n` para `\n`) em arquivos de script e SQL antes de subir os containers, evitando incompatibilidades no Linux do Docker.

1.  **Inicie o ambiente:**
    ```cmd
    local-env-setup.bat up
    ```

2.  **Verifique o status:**
    ```cmd
    local-env-setup.bat status
    ```

3.  **Pare o ambiente:**
    ```cmd
    local-env-setup.bat stop
    ```

4.  **Remova o ambiente (containers e volumes):**
    ```cmd
    local-env-setup.bat down
    ```

### 📊 Visualização do Kafbat UI

Após os comandos de subida, você pode conferir se o **Kafka** foi inicializado com sucesso acessando o dashboard visual do Kafbat UI.
*   **Acesse no navegador:** [http://localhost:9090/](http://localhost:9090/)

## 🔐 Credenciais (Desenvolvimento)

As credenciais estão predefinidas no arquivo `.env` para facilitar o setup local. É altamente recomendado que você teste as conexões usando as ferramentas listadas abaixo para garantir que o ambiente subiu corretamente.

### PostgreSQL (Testar no DBeaver)

*   **Host**: `localhost`
*   **Porta**: `5432`

**Bancos criados:**
*   **Banco**: `customers`
    *   **Usuário**: `customers_db_user`
    *   **Senha**: `customers_db_pass`
*   **Banco**: `insurance`
    *   **Usuário**: `insurance_db_user`
    *   **Senha**: `insurance_db_pass`

### MongoDB (Testar no MongoDB Atlas / Compass)

*   **Host**: `localhost`
*   **Porta**: `27017`

**Bancos criados:**
*   **Banco**: `insurance`
    *   **Usuário**: `insurance_db_user`
    *   **Senha**: `insurance_db_pass`
    *   *Connection String*: `mongodb://insurance_db_user:insurance_db_pass@localhost:27017/insurance?authSource=insurance`

## 📝 Notas Técnicas

*   O `docker-compose.yml` inclui `healthchecks` para garantir que as aplicações só iniciem após os bancos de dados e serviços auxiliares (como Kafka e Redis) estarem prontos.
*   O script de inicialização em `postgres/` cria as credenciais e o banco. As tabelas serão criadas via scripts de migração, pelo Flyway de cada projeto.
*   O script de inicialização em `mongo/` cria o banco, as credenciais e define as permissões necessárias.
*   O script de inicialização em `kafka/` provê um script para a criação dos tópicos necessários após a inicialização do broker.
*   Cada serviço possui o seu próprio `README.md` com os detalhes específicos de cada implementação. 