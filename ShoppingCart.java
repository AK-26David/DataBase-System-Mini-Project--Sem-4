package com.example.demo;

import javafx.application.Application;
import javafx.geometry.Insets;
import javafx.scene.Scene;
import javafx.scene.control.*;
import javafx.scene.layout.*;
import javafx.stage.Stage;
import java.sql.*;

public class ShoppingCart extends Application {

    private static final String JDBC_URL = "jdbc:oracle:thin:@localhost:1521:XE";
    private static final String USERNAME = "system";
    private static final String PASSWORD = "dnn12345";

    private Connection connection;

    @Override
    public void start(Stage primaryStage) {
        try {
            // Connect to the database
            connection = DriverManager.getConnection(JDBC_URL, USERNAME, PASSWORD);

            // UI Components
            TextField idField = new TextField(); // New TextField for customer ID
            TextField nameField = new TextField();
            TextField emailField = new TextField();
            ListView<String> productList = new ListView<>();
            Button addButton = new Button("Add to Cart");

// Fetch products from the database and populate the list view
            fetchProducts(productList);



            // Fetch products from the database and populate the list view
            fetchProducts(productList);

            // Event handler for add button
// Event handler for add button
            addButton.setOnAction(event -> {
                // Retrieve customer details from the text fields
                int customerId = 0;
                try {
                    customerId = Integer.parseInt(idField.getText().trim());
                } catch (NumberFormatException e) {
                    showAlert("Please enter a valid customer ID.");
                    return;
                }
                String name = nameField.getText().trim();
                String email = emailField.getText().trim();
                String selectedProduct = productList.getSelectionModel().getSelectedItem();

                if (customerId > 0 && !name.isEmpty() && !email.isEmpty() && selectedProduct != null) {
                    // Insert customer details into the database
                    boolean success = insertCustomerDetails(customerId, name, email);
                    if (success) {
                        // Get the selected product id
                        int productId = getProductId(selectedProduct);

                        // Add item to the shopping cart
                        addToCart(customerId);
                    }
                } else {
                    showAlert("Please fill in all fields, select a product, and enter a valid customer ID.");
                }
            });


            // Layout
            VBox root = new VBox(10);
            root.setPadding(new Insets(10));
            root.getChildren().addAll(
                    new Label("Enter Your Details:"),
                    new Label("ID:"), // Label for customer ID
                    idField, // TextField for customer ID
                    new Label("Name:"),
                    nameField,
                    new Label("Email:"),
                    emailField,
                    new Label("Select Product:"),
                    productList,
                    addButton
            );
            productList.setPrefSize(200, 200);
            productList.setMaxHeight(200);

            // Scene
            Scene scene = new Scene(root, 500, 500);

            // Stage
            primaryStage.setScene(scene);
            primaryStage.setTitle("Shopping Cart");
            primaryStage.show();

            // Close JDBC connection when the application is closed
            primaryStage.setOnCloseRequest(event -> {
                try {
                    if (connection != null && !connection.isClosed()) {
                        connection.close();
                    }
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            });
        } catch (SQLException e) {
            e.printStackTrace();
            showAlert("Failed to connect to the database.");
        }
    }

    private void fetchProducts(ListView<String> productList) {
        try (Statement statement = connection.createStatement();
             ResultSet resultSet = statement.executeQuery("SELECT name FROM Product")) {
            while (resultSet.next()) {
                productList.getItems().add(resultSet.getString("name"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
            showAlert("Failed to fetch products from the database.");
        }
    }

    private boolean insertCustomerDetails(int id, String name, String email) {
        try (PreparedStatement statement = connection.prepareStatement("INSERT INTO Customers (id, name, email) VALUES (?, ?, ?)")) {
            statement.setInt(1, id);
            statement.setString(2, name);
            statement.setString(3, email);
            int rowsInserted = statement.executeUpdate();
            return rowsInserted > 0; // Return true if at least one row is inserted
        } catch (SQLException e) {
            e.printStackTrace();
            showAlert("Failed to insert customer details into the database.");
            return false;
        }
    }


    private int getProductId(String productName) {
        try (PreparedStatement statement = connection.prepareStatement("SELECT id FROM Product WHERE name = ?")) {
            statement.setString(1, productName);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return resultSet.getInt("id");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            showAlert("Failed to get product ID from the database.");
        }
        return -1; // Return -1 if product not found
    }

    private void addToCart(int customerId) {
        Connection connection = null;
        PreparedStatement shoppingCartStatement = null;
        ResultSet generatedKeys = null;

        try {
            connection = DriverManager.getConnection(JDBC_URL, USERNAME, PASSWORD);

            // Insert into ShoppingCart table and retrieve generated key
            shoppingCartStatement = connection.prepareStatement(
                    "INSERT INTO ShoppingCart (customer_id, creation_date) VALUES (?, SYSDATE)",
                    Statement.RETURN_GENERATED_KEYS
            );
            shoppingCartStatement.setInt(1, customerId);  // Make sure customerId is an integer
            int rowsInserted = shoppingCartStatement.executeUpdate();

            if (rowsInserted > 0) {
                generatedKeys = shoppingCartStatement.getGeneratedKeys();
                if (generatedKeys.next()) {
                    int cartId = generatedKeys.getInt(1); // Ensure this matches the column index
                    showAlert("Shopping cart created successfully with ID: " + cartId);
                }
            } else {
                showAlert("Failed to create a shopping cart entry.");
            }
        } catch (SQLException e) {
            System.out.println("SQL Error: " + e.getMessage());
            e.printStackTrace();
        } finally {
            // Close all resources to prevent memory leaks
            try {
                if (generatedKeys != null) generatedKeys.close();
                if (shoppingCartStatement != null) shoppingCartStatement.close();
                if (connection != null) connection.close();
            } catch (SQLException se) {
                se.printStackTrace();
            }
        }
    }

    private void showAlert(String message) {
        Alert alert = new Alert(Alert.AlertType.ERROR);
        alert.setTitle("Error");
        alert.setHeaderText(null);
        alert.setContentText(message);
        alert.showAndWait();
    }

    public static void main(String[] args) {
        launch(args);
    }
}
