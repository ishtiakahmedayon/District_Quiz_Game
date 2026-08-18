# QuizProject
Java Quiz Web App using Java Servelet + JDBC + MySQL



# ☕ Java Final Exam — Answer Key (L1–L12)

Brief academic answers with working code for every sub-question.

---

## L1 — Encapsulation and Polymorphism

**1.1 Encapsulation:** Binding data (fields) and methods into a single unit (class), and restricting direct access to fields using access modifiers (`private`), exposing controlled access via public getters/setters. Analogy: a capsule medicine — the contents are hidden inside a shell, accessed only through defined means.

**1.2 Polymorphism:** "Many forms" — same method name behaves differently.
- **Compile-time (static):** resolved by the compiler using method signatures — *overloading*. E.g. `add(int,int)` vs `add(double,double)`.
- **Run-time (dynamic):** resolved by JVM based on actual object type — *overriding*. E.g. `Shape ref = new Circle(); ref.area();`

**1.3 Code:**
```java
class BankAccount {
    private double balance;

    public double getBalance() { return balance; }

    public void deposit(double amount) {
        balance += amount;
        System.out.println("Deposited: " + amount);
    }

    public void deposit(double amount, String remarks) {
        balance += amount;
        System.out.println("Deposited: " + amount + " | Remarks: " + remarks);
    }
}

public class Main {
    public static void main(String[] args) {
        BankAccount acc = new BankAccount();
        acc.deposit(500.0);
        acc.deposit(1000.0, "Salary credit");
        System.out.println("Balance: " + acc.getBalance());
    }
}
```

---

## L2 — Overloading vs Overriding (Early vs Late Binding)

**2.1 Comparison table**

| Aspect | Overloading | Overriding |
|---|---|---|
| Definition | Same method name, different parameter list | Same signature, redefined in subclass |
| Class involved | Same class | Parent–child (inheritance) |
| Parameters | Must differ | Must be identical |
| Return type | Can differ | Same or covariant |
| Binding | Compile-time | Run-time |

**2.2 Binding:** Early (static) binding resolves the method call at compile time based on the reference type — used for overloading. Late (dynamic) binding resolves at run time based on the actual object type — used for overriding, since the JVM only knows the real object when the program executes (via v-table lookup).

**2.3 Code:**
```java
abstract class Shape {
    abstract double area();
    void describe(String name) { System.out.println(name + " is a shape."); }
    void describe(String name, int sides) {
        System.out.println(name + " has " + sides + " sides.");
    }
}
class Circle extends Shape {
    double radius;
    Circle(double r) { radius = r; }
    double area() { return Math.PI * radius * radius; }
}
class Rectangle extends Shape {
    double length, width;
    Rectangle(double l, double w) { length = l; width = w; }
    double area() { return length * width; }
}
public class Main {
    public static void main(String[] args) {
        Shape s1 = new Circle(5);
        Shape s2 = new Rectangle(4, 6);
        System.out.println("Circle area: " + s1.area());     // late binding
        System.out.println("Rectangle area: " + s2.area());  // late binding
        s1.describe("Circle");            // early binding
        s2.describe("Rectangle", 4);      // early binding
    }
}
```
Sample output:
```
Circle area: 78.53981633974483
Rectangle area: 24.0
Circle is a shape.
Rectangle has 4 sides.
```

---

## L3 — Abstract Class vs Interface

**3.1 Definitions & differences:**
- **Abstract class:** a class declared `abstract`, may have both concrete and abstract methods; cannot be instantiated directly.
- **Interface:** a contract of method signatures (Java 8+ also allows `default`/`static` methods); implementing classes must provide bodies.

| Feature | Abstract Class | Interface |
|---|---|---|
| Fields | Instance variables allowed | Only `public static final` constants |
| Constructors | Allowed | Not allowed |
| Method body | Mix of abstract + concrete | Default/static only |
| Multiple inheritance | Single class extension only | A class can implement many interfaces |

**3.2 When to choose:**
- Abstract class → "is-a" relationship with shared code, e.g. `Vehicle` → `Car`, `Bike` sharing `startEngine()`.
- Interface → "can-do" capability across unrelated classes, e.g. `Insurable` implemented by `Car`, `House`, `Person`.

**3.3 Code:**
```java
abstract class Vehicle {
    void startEngine() { System.out.println("Engine started..."); }
    abstract String fuelType();
}
interface Insurable {
    double calculatePremium();
}
class Car extends Vehicle implements Insurable {
    String fuelType() { return "Petrol"; }
    public double calculatePremium() { return 5000.0; }
}
public class Main {
    public static void main(String[] args) {
        Car c = new Car();
        c.startEngine();
        System.out.println("Fuel: " + c.fuelType());
        System.out.println("Premium: " + c.calculatePremium());
    }
}
```
*Vehicle is abstract because Car "is-a" Vehicle and shares `startEngine()`. Insurable is an interface because insurance is a "can-do" capability not tied to the vehicle hierarchy.*

---

## L4 — Collection Framework

**4.1 ArrayList vs Vector vs LinkedList**

| Feature | ArrayList | Vector | LinkedList |
|---|---|---|---|
| Structure | Dynamic array | Dynamic array | Doubly linked list |
| Synchronized | No | Yes | No |
| Random access | Fast O(1) | Fast O(1) | Slow O(n) |
| Insert/Delete (middle) | Slow (shifting) | Slow (shifting) | Fast O(1) once positioned |

**4.2 Set implementations:**
- `HashSet` — no order, backed by hash table, fastest.
- `LinkedHashSet` — maintains insertion order via a linked list on top of hashing.
- `TreeSet` — maintains **sorted (natural or comparator) order** using a Red-Black Tree (`TreeMap` internally); every `add` places elements in sorted position.

**4.3 Code:**
```java
import java.util.*;

public class Main {
    public static void main(String[] args) {
        ArrayList<String> list = new ArrayList<>(
            Arrays.asList("Rahim", "Karim", "Anik", "Bina", "Zayed"));
        TreeSet<String> set = new TreeSet<>(list);

        System.out.println("ArrayList (insertion order):");
        for (String name : list) System.out.println(name);

        System.out.println("TreeSet (sorted order):");
        for (String name : set) System.out.println(name);
    }
}
```
*Comment: `ArrayList` preserves insertion order; `TreeSet` reorders elements alphabetically and removes duplicates.*

---

## L5 — Multithreading & Custom Exception Handling

**5.1 Ways to create threads:** (1) `extends Thread`, (2) `implements Runnable`, (3) `ExecutorService`/`Callable` (thread pools). **Preferred:** `Runnable`/`ExecutorService`, because Java supports single inheritance — implementing an interface keeps the class free to extend something else, and `ExecutorService` gives better lifecycle/thread-pool management.

**5.2 Code:**
```java
class MyThread extends Thread {
    public void run() {
        for (int i = 1; i <= 5; i++) System.out.println("Thread-A: " + i);
    }
}
class MyRunnable implements Runnable {
    public void run() {
        for (int i = 1; i <= 5; i++) System.out.println("Thread-B: " + i);
    }
}
public class Main {
    public static void main(String[] args) {
        MyThread t1 = new MyThread();
        Thread t2 = new Thread(new MyRunnable());
        t1.start();
        t2.start();
    }
}
```

**5.3 Code:**
```java
class InvalidRadiusException extends Exception {
    public InvalidRadiusException(String msg) { super(msg); }
}
class Circle {
    private double radius;
    public Circle(double r) throws InvalidRadiusException {
        if (r < 0) throw new InvalidRadiusException("Radius cannot be negative: " + r);
        this.radius = r;
    }
    double area() { return Math.PI * radius * radius; }
}
public class Main {
    public static void main(String[] args) {
        try {
            Circle c = new Circle(-5);
            System.out.println("Area: " + c.area());
        } catch (InvalidRadiusException e) {
            System.out.println("Error: " + e.getMessage());
        }
    }
}
```

---

## L6 — JDBC with MySQL/Oracle (MVC Pattern)

**6.1 Steps:** (1) Load driver (`Class.forName` — optional since JDBC 4.0 auto-loads), (2) `DriverManager.getConnection(url, user, pass)` → `Connection`, (3) create `PreparedStatement` with SQL, (4) `executeUpdate()`/`executeQuery()` → `ResultSet`, (5) process results, (6) close resources.

**6.2 MVC mapping:** **Model** = POJO (`Student`) holding data; **Controller** = DAO class performing DB operations using JDBC; **View** = the class/UI collecting input and displaying output (here, `Main`). Separation keeps DB logic decoupled from presentation.

**6.3 Code:**
```java
// Model
class Student {
    int id; String name; double cgpa;
    Student(int id, String name, double cgpa) {
        this.id = id; this.name = name; this.cgpa = cgpa;
    }
}

// Controller / DAO
import java.sql.*;
class StudentDAO {
    public void insert(Student s) {
        String url = "jdbc:mysql://localhost:3306/student_db";
        String sql = "INSERT INTO Students(id, name, cgpa) VALUES (?, ?, ?)";
        try (Connection con = DriverManager.getConnection(url, "root", "password");
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, s.id);
            ps.setString(2, s.name);
            ps.setDouble(3, s.cgpa);
            ps.executeUpdate();
            System.out.println("Inserted successfully.");
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}

// View
import java.util.Scanner;
public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        System.out.print("ID: "); int id = sc.nextInt();
        System.out.print("Name: "); String name = sc.next();
        System.out.print("CGPA: "); double cgpa = sc.nextDouble();

        Student s = new Student(id, name, cgpa);
        new StudentDAO().insert(s);
    }
}
```

---

## L7 — JavaFX — House Loan Calculator

**7.1 Structure:** A JavaFX app extends `Application` and overrides `start(Stage primaryStage)`, the entry point launched by `launch()`. A `Scene` (containing a layout like `GridPane`/`VBox`) is set on the `Stage` (the window), which is then shown via `primaryStage.show()`.

**7.2 & 7.3 Code:**
```java
import javafx.application.Application;
import javafx.geometry.Insets;
import javafx.scene.Scene;
import javafx.scene.control.*;
import javafx.scene.layout.GridPane;
import javafx.stage.Stage;

public class LoanCalculator extends Application {
    public void start(Stage stage) {
        GridPane grid = new GridPane();
        grid.setPadding(new Insets(15));
        grid.setVgap(8); grid.setHgap(8);

        TextField loanField = new TextField();
        TextField rateField = new TextField();
        TextField yearsField = new TextField();
        Button calcBtn = new Button("Calculate");
        Label monthlyLbl = new Label(), totalLbl = new Label(), diffLbl = new Label();

        grid.addRow(0, new Label("Loan Amount:"), loanField);
        grid.addRow(1, new Label("Annual Rate (%):"), rateField);
        grid.addRow(2, new Label("Number of Years:"), yearsField);
        grid.add(calcBtn, 1, 3);
        grid.addRow(4, new Label("Monthly Installment:"), monthlyLbl);
        grid.addRow(5, new Label("Total Payment:"), totalLbl);
        grid.addRow(6, new Label("Difference:"), diffLbl);

        calcBtn.setOnAction(e -> {
            double p = Double.parseDouble(loanField.getText());
            double annualRate = Double.parseDouble(rateField.getText());
            int years = Integer.parseInt(yearsField.getText());

            double r = annualRate / 12 / 100;
            int n = years * 12;
            double m = p * r * Math.pow(1 + r, n) / (Math.pow(1 + r, n) - 1);
            double total = m * n;
            double diff = total - p;

            monthlyLbl.setText(String.format("%.2f", m));
            totalLbl.setText(String.format("%.2f", total));
            diffLbl.setText(String.format("%.2f", diff));
        });

        stage.setScene(new Scene(grid, 350, 300));
        stage.setTitle("House Loan Calculator");
        stage.show();
    }
    public static void main(String[] args) { launch(args); }
}
```

---

## L8 — Socket Programming & Java RMI (Chat System)

**8.1 Socket vs RMI:**
- **Socket:** low-level, raw byte/text streams over TCP; full control over protocol; more boilerplate.
- **RMI:** high-level, lets you invoke methods on remote Java objects as if local; easier for structured Java-to-Java object communication; less flexible across non-Java clients.
- **Prefer Socket** for cross-language/lightweight protocols; **prefer RMI** for pure-Java distributed applications needing object-oriented remote calls.

**8.2 Server code:**
```java
import java.io.*;
import java.net.*;

public class ChatServer {
    public static void main(String[] args) throws IOException {
        ServerSocket serverSocket = new ServerSocket(5000);
        System.out.println("Server waiting for connection...");
        Socket socket = serverSocket.accept();
        System.out.println("Client connected.");

        BufferedReader in = new BufferedReader(new InputStreamReader(socket.getInputStream()));
        PrintWriter out = new PrintWriter(socket.getOutputStream(), true);

        String message = in.readLine();
        System.out.println("Client says: " + message);
        out.println("Message received: " + message);

        socket.close();
        serverSocket.close();
    }
}
```

**8.3 Client code:**
```java
import java.io.*;
import java.net.*;
import java.util.Scanner;

public class ChatClient {
    public static void main(String[] args) throws IOException {
        Socket socket = new Socket("localhost", 5000);
        PrintWriter out = new PrintWriter(socket.getOutputStream(), true);
        BufferedReader in = new BufferedReader(new InputStreamReader(socket.getInputStream()));

        Scanner sc = new Scanner(System.in);
        System.out.print("Enter message: ");
        String msg = sc.nextLine();
        out.println(msg);

        String reply = in.readLine();
        System.out.println("Server reply: " + reply);

        socket.close();
    }
}
```

---

## L9 — Servlet + JSP + JDBC CRUD (Student Records)

**9.1 Setup steps:** (1) Create MySQL database `student_db` with table `Students(id, name, cgpa)`. (2) Add MySQL Connector/J to project (`WEB-INF/lib`). (3) Map servlet via `@WebServlet("/addStudent")` or `web.xml`. (4) Use JDBC URL `jdbc:mysql://localhost:3306/student_db` with credentials for the connection.

**9.2 Servlet doPost():**
```java
import java.io.*;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;

@WebServlet("/addStudent")
public class StudentServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        String name = req.getParameter("name");
        double cgpa = Double.parseDouble(req.getParameter("cgpa"));

        String url = "jdbc:mysql://localhost:3306/student_db";
        String sql = "INSERT INTO Students(id, name, cgpa) VALUES (?, ?, ?)";

        try (Connection con = DriverManager.getConnection(url, "root", "password");
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.setString(2, name);
            ps.setDouble(3, cgpa);
            ps.executeUpdate();
            resp.getWriter().println("Student added successfully.");
        } catch (SQLException e) {
            resp.getWriter().println("Error: " + e.getMessage());
        }
    }
}
```

**9.3 JSP display page:**
```jsp
<%@ page import="java.sql.*" %>
<html><body>
<h2>Student Records</h2>
<table border="1">
<tr><th>ID</th><th>Name</th><th>CGPA</th></tr>
<%
Connection con = DriverManager.getConnection(
    "jdbc:mysql://localhost:3306/student_db", "root", "password");
Statement st = con.createStatement();
ResultSet rs = st.executeQuery("SELECT * FROM Students");
while (rs.next()) {
%>
<tr>
    <td><%= rs.getInt("id") %></td>
    <td><%= rs.getString("name") %></td>
    <td><%= rs.getDouble("cgpa") %></td>
</tr>
<% } con.close(); %>
</table>
</body></html>
```

---

## L10 — Spring Boot REST API with JPA/ORM

**10.1 Setup:** Create a Spring Boot project (via Spring Initializr) with Maven dependencies `spring-boot-starter-web` (REST + embedded Tomcat), `spring-boot-starter-data-jpa` (ORM), and the MySQL connector (`mysql-connector-j`). Configure DB in `application.properties`. **Embedded Tomcat** auto-starts on `mvn spring-boot:run`, so no external server deployment is needed — the app is self-contained.

**10.2 Entity + Repository:**
```java
import jakarta.persistence.*;

@Entity
public class Student {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String name;
    private double cgpa;

    // getters and setters
    public Long getId() { return id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public double getCgpa() { return cgpa; }
    public void setCgpa(double cgpa) { this.cgpa = cgpa; }
}
```
```java
import org.springframework.data.jpa.repository.JpaRepository;

public interface StudentRepository extends JpaRepository<Student, Long> { }
```

**10.3 REST Controller:**
```java
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/students")
public class StudentController {
    private final StudentRepository repo;
    public StudentController(StudentRepository repo) { this.repo = repo; }

    @GetMapping
    public List<Student> getAll() { return repo.findAll(); }

    @PostMapping
    public Student add(@RequestBody Student s) { return repo.save(s); }
}
```

---

## L11 — Servlet CRUD — District Quiz Game

**11.1 Schema design:** Four tables — `CATEGORY` (Crops / Geography / Institutions), `QUESTION` (linked to a category, with 4 options + correct option), `PLAYER` (player identity), `PLAYER_SCORE` (score per play session, linked to player). Separating `CATEGORY` and `QUESTION` allows filtering/expanding quiz topics; separating `PLAYER` and `PLAYER_SCORE` supports multiple attempts per player (1-to-many) for a leaderboard.

**11.2 Servlet — save score:**
```java
import java.io.*;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;

@WebServlet("/saveScore")
public class ScoreServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String name = req.getParameter("name");
        int score = Integer.parseInt(req.getParameter("score"));

        String url = "jdbc:mysql://localhost:3306/quiz_db";
        String sql = "INSERT INTO PlayerScore(name, total_score, played_on) VALUES (?, ?, NOW())";

        try (Connection con = DriverManager.getConnection(url, "root", "password");
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setInt(2, score);
            ps.executeUpdate();
            resp.getWriter().println("Score saved for " + name);
        } catch (SQLException e) {
            resp.getWriter().println("Error: " + e.getMessage());
        }
    }
}
```

**11.3 Quiz logic:**
```java
class Question {
    String text, optA, optB, optC, optD, correct;
    Question(String text, String a, String b, String c, String d, String correct) {
        this.text = text; this.optA = a; this.optB = b;
        this.optC = c; this.optD = d; this.correct = correct;
    }
    boolean checkAnswer(String given) { return correct.equalsIgnoreCase(given); }
}

import java.util.*;
public class QuizGame {
    public static void main(String[] args) {
        List<Question> questions = new ArrayList<>();
        questions.add(new Question("Main crop of Tangail district?", "A) Rice", "B) Tea", "C) Coffee", "D) Cotton", "A"));
        questions.add(new Question("Tangail is located in which division?", "A) Khulna", "B) Dhaka", "C) Rajshahi", "D) Sylhet", "B"));
        questions.add(new Question("Famous academic institution in Tangail?", "A) BUET", "B) DU", "C) Mawlana Bhashani Science & Technology University", "D) CU", "C"));

        Scanner sc = new Scanner(System.in);
        int score = 0;
        for (Question q : questions) {
            System.out.println(q.text);
            System.out.println(q.optA + " " + q.optB + " " + q.optC + " " + q.optD);
            System.out.print("Your answer: ");
            String ans = sc.next();
            if (q.checkAnswer(ans)) { score++; System.out.println("Correct!"); }
            else System.out.println("Wrong! Correct: " + q.correct);
        }
        System.out.println("Final Score: " + score + "/" + questions.size());
    }
}
```

---

## L12 — GoF Design Patterns

**12.1 Creational patterns:**

| Pattern | Purpose |
|---|---|
| Singleton | Ensure only one instance of a class exists, with a global access point |
| Factory Method | Delegate object creation to subclasses |
| Abstract Factory | Create families of related objects without specifying concrete classes |
| Builder | Construct complex objects step-by-step |
| Prototype | Create new objects by cloning existing ones |

**12.2 Structural patterns:**

| Pattern | Purpose |
|---|---|
| Adapter | Convert one interface into another expected by the client |
| Bridge | Decouple abstraction from implementation so both vary independently |
| Composite | Treat individual objects and compositions of objects uniformly (tree structures) |
| Decorator | Add responsibilities to an object dynamically without subclassing |
| Facade | Provide a simplified interface to a complex subsystem |
| Flyweight | Share fine-grained objects to reduce memory usage |
| Proxy | Provide a placeholder/surrogate to control access to another object |

**12.3 Code:**
```java
// Thread-safe Singleton
class Singleton {
    private static volatile Singleton instance;
    private Singleton() { }
    public static Singleton getInstance() {
        if (instance == null) {
            synchronized (Singleton.class) {
                if (instance == null) instance = new Singleton();
            }
        }
        return instance;
    }
}

// Adapter
interface Target {
    void request();
}
class Adaptee {
    void specificRequest() { System.out.println("Adaptee's specific request"); }
}
class Adapter implements Target {
    private Adaptee adaptee;
    Adapter(Adaptee adaptee) { this.adaptee = adaptee; }
    public void request() { adaptee.specificRequest(); }
}

public class Main {
    public static void main(String[] args) {
        Singleton s1 = Singleton.getInstance();
        Singleton s2 = Singleton.getInstance();
        System.out.println("Same instance? " + (s1 == s2));

        Target t = new Adapter(new Adaptee());
        t.request();
    }
}
```

---

*End of answer key — all 12 sets (36 sub-questions) covered.*
