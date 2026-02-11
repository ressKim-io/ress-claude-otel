#!/bin/bash
# ============================================================
# Claude Code OTel 텔레메트리 환경변수 설정
# 사용법: source setup-env.sh
# ============================================================

# 텔레메트리 활성화
export CLAUDE_CODE_ENABLE_TELEMETRY=1

# OTLP exporter 설정
export OTEL_METRICS_EXPORTER=otlp
export OTEL_LOGS_EXPORTER=otlp

# gRPC 프로토콜 사용 (포트: 14317)
export OTEL_EXPORTER_OTLP_PROTOCOL=grpc
export OTEL_EXPORTER_OTLP_ENDPOINT=http://localhost:14317

# Export 주기 (빠른 로컬 피드백용)
export OTEL_METRIC_EXPORT_INTERVAL=10000
export OTEL_LOGS_EXPORT_INTERVAL=5000

echo "Claude Code OTel 텔레메트리 설정 완료"
echo ""
echo "  CLAUDE_CODE_ENABLE_TELEMETRY = $CLAUDE_CODE_ENABLE_TELEMETRY"
echo "  OTEL_METRICS_EXPORTER        = $OTEL_METRICS_EXPORTER"
echo "  OTEL_LOGS_EXPORTER           = $OTEL_LOGS_EXPORTER"
echo "  OTEL_EXPORTER_OTLP_PROTOCOL  = $OTEL_EXPORTER_OTLP_PROTOCOL"
echo "  OTEL_EXPORTER_OTLP_ENDPOINT  = $OTEL_EXPORTER_OTLP_ENDPOINT"
echo "  OTEL_METRIC_EXPORT_INTERVAL  = ${OTEL_METRIC_EXPORT_INTERVAL}ms"
echo "  OTEL_LOGS_EXPORT_INTERVAL    = ${OTEL_LOGS_EXPORT_INTERVAL}ms"
echo ""
echo "Grafana:    http://localhost:13000  (admin / admin)"
echo "Prometheus: http://localhost:19090"
echo "Loki:       http://localhost:13100"
echo ""
echo "이제 claude 명령을 실행하면 텔레메트리가 수집됩니다."
