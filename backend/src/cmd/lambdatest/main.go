package main

import (
	"context"
	"fmt"
	"net/http"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
)

func HandleRequest(ctx context.Context, req events.APIGatewayProxyRequest) (*events.APIGatewayProxyResponse, error) {
	fmt.Printf("Request: %s: %s\n", req.HTTPMethod, req.Path)
	if req.HTTPMethod == http.MethodOptions {

		return createOptionsResponse()
	}

	fmt.Printf("headers: %+v\n", req.Headers)
	accessToken := req.Headers["Authorization"]
	fmt.Printf("authorization: %v", accessToken)

	return createResponse(http.StatusOK, `{"msg":"hello"}`, "application/json")
}

func createResponse(code int, body, contentType string) (*events.APIGatewayProxyResponse, error) {
	resp := events.APIGatewayProxyResponse{
		StatusCode: code,
		Headers: map[string]string{
			"Access-Control-Allow-Origin": "*",
			"Content-Type":                contentType},
		MultiValueHeaders: nil,
		Body:              body,
		IsBase64Encoded:   false,
	}

	return &resp, nil
}

func createOptionsResponse() (*events.APIGatewayProxyResponse, error) {
	resp := events.APIGatewayProxyResponse{
		StatusCode: http.StatusOK,
		Headers: map[string]string{
			"Access-Control-Allow-Origin":  "*",
			"Access-Control-Allow-Headers": "Authorization",
			"Access-Control-Allow-Methods": "GET,POST",
		},
		MultiValueHeaders: nil,
		Body:              "",
		IsBase64Encoded:   false,
	}
	return &resp, nil
}

func main() {
	lambda.Start(HandleRequest)
}
