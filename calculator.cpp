#include "crow.h"
#include <sstream>
#include <fstream>
#include <cmath>

double evaluateExpression(const std::string &expression) {
    std::istringstream stream(expression);
    char op;
    double num1, num2;
    stream >> num1;
    if (stream >> op) {
        stream >> num2;
        switch (op) {
            case '+': return num1 + num2;
            case '-': return num1 - num2;
            case '*': return num1 * num2;
            case '/': return num1 / num2;
            default: return NAN;  // Return NaN for unsupported operators
        }
    }
    return num1;  // Return the first number if no operator is found
}

int main() {
    crow::SimpleApp app;

    // Serve the index.html file for the root route
    CROW_ROUTE(app, "/")
    ([]() {
        std::ifstream file("/home/ubuntu/DIS_Kursova/index.html");  // Make sure the HTML file is in the same directory
        if (!file.is_open()) {
            return crow::response{500, "Error: Could not load index.html"};
        }
        std::stringstream buffer;
        buffer << file.rdbuf();
        return crow::response{buffer.str()};
    });

    // Define the calculation route
    CROW_ROUTE(app, "/api/calculate")
    .methods("GET"_method)
    ([](const crow::request& req) {
        auto expression = req.url_params.get("expression");
        if (expression) {
            double result = evaluateExpression(expression);
            if (std::isnan(result)) {
                crow::json::wvalue error_response;
                error_response["error"] = "Invalid expression or operator";
                return crow::response{400, error_response.dump()};
            }
            crow::json::wvalue json_response;
            json_response["result"] = result;
            return crow::response{200, json_response.dump()};
        }

        // Return a 400 error if the expression is missing
        crow::json::wvalue error_response;
        error_response["error"] = "Expression parameter is missing";
        return crow::response{400, error_response.dump()};
    });

    // Run the application
    app.port(18080).multithreaded().run();
}

