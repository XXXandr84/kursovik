---
global:
  scrape_interval: '5s'

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets:
        - 'localhost:9090'

  - job_name: 'ui'
    static_configs:
      - targets:
        - '${addrs[0]}:32092'
#        - 'ui:8000'

  - job_name: 'search-crawler'
    static_configs:
      - targets:
        - '${addrs[0]}:32092'
#        - 'crawler:8000'
