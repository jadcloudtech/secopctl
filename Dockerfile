FROM golang:1.17 as builder

WORKDIR /workspace
# Copy the Go Modules manifests
COPY ./ ./
RUN go mod download
ADD ./cmd /cmd

# Build
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 GO111MODULE=on go build -a -o secopctl main.go

# Use distroless as minimal base image to package the manager binary
# Refer to https://github.com/GoogleContainerTools/distroless for more details
FROM gcr.io/distroless/static:nonroot
WORKDIR /
COPY --from=builder /workspace/main.go .
USER 65532:65532

ENTRYPOINT ["/secopctl"]
