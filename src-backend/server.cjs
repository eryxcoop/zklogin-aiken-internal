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
    const responseObject = {
        message: 'Hello, World!',
        status: 'success',
        walletAddress: 'addr1q9sp3v7h0xt82l9ex9jsc9xzt2v5v74j9r7p9x8mrw5v9fppp58y7xg6g7k65c5pgvvxdplm7w07czz7e4dfflpnldwsw6x9ru'
    };

    // Set the response header with status code 200 (OK) and content type
    res.writeHead(200, {'Content-Type': 'application/json'});
    // Send the response body and close the connection
    res.end(JSON.stringify(responseObject));
};

// Create the server with our request listener
const server = http.createServer(requestListener);

// Start listening for connections
server.listen(port, host, () => {
    console.log(`Server is running on http://${host}:${port}`);
});
