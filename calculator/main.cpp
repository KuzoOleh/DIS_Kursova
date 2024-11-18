#include "crow.h"

int main() {
    crow::SimpleApp app;

    // Enable CORS
    app.use([&](const crow::request& req, crow::response& res) {
        res.add_header("Access-Control-Allow-Origin", "*");  // Allow all origins
        res.add_header("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE");
        res.add_header("Access-Control-Allow-Headers", "Content-Type");
    });

    // Serve the HTML file
    CROW_ROUTE(app, "/")([]() {
        return crow::mustache::load("index.html").render();
    });

    // Arithmetic operations
    CROW_ROUTE(app, "/add/<int>/<int>")([](int a, int b) {
        return crow::response(std::to_string(a + b));
    });

    CROW_ROUTE(app, "/subtract/<int>/<int>")([](int a, int b) {
        return crow::response(std::to_string(a - b));
    });

    CROW_ROUTE(app, "/multiply/<int>/<int>")([](int a, int b) {
        return crow::response(std::to_string(a * b));
    });

    CROW_ROUTE(app, "/divide/<int>/<int>")([](int a, int b) {
        if (b == 0) {
            return crow::response(400, "Division by zero is not allowed");
        }
        return crow::response(std::to_string(static_cast<double>(a) / b));
    });

    // Start the Crow server
    app.bindaddr("0.0.0.0").port(18080).multithreaded().run();

    return 0;
}
