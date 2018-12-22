package main

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestMessage(t *testing.T) {
	assert.Equal(t, "Hello World", Message())
}
