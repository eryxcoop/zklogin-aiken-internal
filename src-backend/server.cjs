// Import the built-in http module
const http = require("http");

const host = 'localhost';
const port = 8000;

// Request listener: handles every incoming HTTP request
const requestListener = function (req, res) {
    // Set the response header with status code 200 (OK) and content type
    res.writeHead(200, {'Content-Type': 'text/plain'});
    // Send the response body and close the connection
    res.end("Hello, World! This is a Node.js server.");
};

// Create the server with our request listener
const server = http.createServer(requestListener);

// Start listening for connections
server.listen(port, host, () => {
    console.log(`Server is running on http://${host}:${port}`);
});