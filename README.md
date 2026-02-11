# ress-claude-otel

로컬 PC에서 Claude Code 사용량을 모니터링하는 OpenTelemetry 스택.

## Architecture

```
Claude Code  ──OTLP(gRPC)──>  OTel Collector  ──>  Prometheus (metrics)
                                      │                     │
                                      └──>  Loki (logs)     │
                                                  │         │
                                                  └──> Grafana (dashboard)
```

## Stack

| Service | Image | Role |
|---------|-------|------|
| OTel Collector | `otel/opentelemetry-collector-contrib` | 텔레메트리 수신 및 라우팅 |
| Prometheus | `prom/prometheus` | 메트릭 저장 및 쿼리 |
| Loki | `grafana/loki` | 로그/이벤트 저장 및 쿼리 |
| Grafana | `grafana/grafana-oss` | 대시보드 시각화 |

## Port Map

프로젝트 포트 충돌 방지를 위해 `1xxxx` 대역 사용.

| Service | Port | Purpose |
|---------|------|---------|
| Grafana | `13000` | Dashboard UI |
| OTel Collector (gRPC) | `14317` | OTLP gRPC receiver |
| OTel Collector (HTTP) | `14318` | OTLP HTTP receiver |
| Prometheus | `19090` | Prometheus UI |
| Loki | `13100` | Log API |
| OTel Exporter | `18889` | Prometheus scrape endpoint |

## Quick Start

### 1. 스택 시작

```bash
cd ~/my-file/project/claude-code-otel
make up
```

### 2. 환경변수 설정

`~/.zshrc`에 아래 내용을 추가하면 모든 터미널에서 자동 적용됨:

```bash
# Claude Code OTel Telemetry
export CLAUDE_CODE_ENABLE_TELEMETRY=1
export OTEL_METRICS_EXPORTER=otlp
export OTEL_LOGS_EXPORTER=otlp
export OTEL_EXPORTER_OTLP_PROTOCOL=grpc
export OTEL_EXPORTER_OTLP_ENDPOINT=http://localhost:14317
export OTEL_METRIC_EXPORT_INTERVAL=10000
export OTEL_LOGS_EXPORT_INTERVAL=5000
```

또는 `source setup-env.sh`로 현재 세션에만 적용 가능.

### 3. 대시보드 확인

```
Grafana:    http://localhost:13000  (admin / admin)
Prometheus: http://localhost:19090
```

## Dashboard Panels

| Section | Panels |
|---------|--------|
| Overview | Active Sessions, Total Cost, Token Usage, Lines of Code |
| Cost & Usage | Cumulative Cost by Model, Token Usage by Type, Token Usage by Model |
| Tool Usage | Tool Usage Rate, Cumulative Tool Usage, Tool Success Rate |
| Performance | API Request Duration by Model, API Error Rate |
| Productivity | Cumulative Code Changes, Development Activity |
| Event Logs | Tool Execution Events, API Error Events |

## Collected Metrics

| Metric | Description |
|--------|-------------|
| `claude_code.cost.usage` | 모델별 비용 (USD) |
| `claude_code.token.usage` | 토큰 사용량 (input/output/cacheRead/cacheCreation) |
| `claude_code.session.count` | 세션 수 |
| `claude_code.lines_of_code.count` | 코드 변경 라인 수 (added/removed) |
| `claude_code.commit.count` | Git 커밋 수 |
| `claude_code.pull_request.count` | PR 생성 수 |
| `claude_code.active_time.total` | 활성 사용 시간 |

## Collected Events (via Loki)

| Event | Description |
|-------|-------------|
| `claude_code.tool_result` | 도구 실행 결과 (이름, 성공여부, 소요시간) |
| `claude_code.api_request` | API 요청 (모델, 비용, 토큰, 응답시간) |
| `claude_code.api_error` | API 에러 (상태코드, 에러메시지) |
| `claude_code.user_prompt` | 사용자 프롬프트 (길이만, 내용은 기본 비활성) |

## Make Commands

```bash
make up       # 스택 시작
make down     # 스택 중지
make restart  # 스택 재시작
make logs     # 전체 로그
make status   # 컨테이너 상태
make clean    # 컨테이너 + 볼륨 삭제
make env      # 환경변수 설정 안내
```

## Notes

- 텔레메트리 수집은 추가 토큰 비용이 발생하지 않음 (로컬 전송만)
- Docker 스택이 꺼져 있으면 수집되지 않지만, Claude Code 자체는 정상 동작
- 꺼져 있는 동안의 데이터는 유실되며, 이전에 쌓인 데이터는 볼륨에 보존됨

## Reference

- [ColeMurray/claude-code-otel](https://github.com/ColeMurray/claude-code-otel)
- [Claude Code Monitoring Docs](https://code.claude.com/docs/en/monitoring-usage)
