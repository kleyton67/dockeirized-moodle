# Moodle no Docker

Baixe o moodle, e exporte para a pasta "moodle" (copie apenas a pasta moodle de dentro do pack);
O repo terá uma estrutura parecida com esta:
.
├── creds-part.sh
├── creds.sh
├── data_moodle
├── docker
├── docker-compose.yml
├── Dockerfile
├── moodle
└── README.MD

Copie o creds-part.sh para o arquivo creds.sh, e execute:

```bash
set -a
chmod +x creds.sh
source creds.sh
docker compose up moodle
```

Pronto, o container será criado.
O moodle está executando na porta 8080 (Atenção para a porta do banco de dados (DBPORT), e do site (WWWROOT)).