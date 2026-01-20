// Import the built-in http module
const http = require("http");

const host = 'localhost';
const port = 8000;

// Request listener: handles every incoming HTTP request
const requestListener = function (req, res) {
    // Set CORS headers to allow requests from localhost:5173
    res.setHeader("Access-Control-Allow-Origin", "http://localhost:5173"); // Allow localhost:5173
    res.setHeader("Access-Control-Allow-Methods", "GET, POST, OPTIONS"); // Allow specific methods
    res.setHeader("Access-Control-Allow-Headers", "Content-Type"); // Allow Content-Type header

    // Handle preflight OPTIONS request
    if (req.method === "OPTIONS") {
        res.writeHead(200);
        res.end();
        return;
    }

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
