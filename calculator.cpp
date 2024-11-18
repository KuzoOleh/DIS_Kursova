#include "crow_all.h"
#include <string>
#include <sstream>

double evaluateExpression(const std::string &expression) {
    // This is a simple way to evaluate an expression.
    // For a real application, use a proper math expression evaluator.
    double result;
    std::istringstream(expression) >> result;
    return result;
}

int main() {
    crow::SimpleApp app;

    CROW_ROUTE(app, "/")
    ([]() {
        return crow::mustache::load("index.html");  // The frontend HTML file
    });

    CROW_ROUTE(app, "/api/calculate")
    .methods("GET"_method)
    ([](const crow::request& req) {
        auto expression = req.url_params.get("expression");
        if (expression) {
            double result = evaluateExpression(expression);
            return crow::json::wvalue{{"result", result}};
        }
        return crow::response(400, "Invalid expression");
    });

    app.port(18080).multithreaded().run();
}

