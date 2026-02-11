.PHONY: help up down logs restart clean status env

help: ## 사용 가능한 명령 보기
	@echo "Claude Code OTel 모니터링 스택"
	@echo "=============================="
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

up: ## 스택 시작
	docker compose up -d
	@echo ""
	@echo "Grafana:    http://localhost:13000  (admin / admin)"
	@echo "Prometheus: http://localhost:19090"

down: ## 스택 중지
	docker compose down

restart: ## 스택 재시작
	docker compose restart

logs: ## 전체 로그 보기
	docker compose logs -f

logs-collector: ## OTel Collector 로그 보기
	docker compose logs -f otel-collector

status: ## 스택 상태 확인
	docker compose ps

clean: ## 컨테이너 및 볼륨 삭제
	docker compose down -v

env: ## 환경변수 설정 안내
	@echo "아래 명령으로 환경변수를 설정하세요:"
	@echo ""
	@echo "  source setup-env.sh"
