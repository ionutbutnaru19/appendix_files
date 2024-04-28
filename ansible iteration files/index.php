<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Telecom Account Management</title>
</head>
<body>
    <h1 style="color: red;">NEW FORM</h1>
    <h1>Welcome to Telecom Account Management</h1>
    <h2>Update your account details by filling the form below!</h2>
    <p>Hostname: <?php echo gethostname(); ?></p> 

    <form>
        <h2>Account Information</h2>
        <label for="name">Name:</label>
        <input type="text" id="name" name="name"><br><br>
        <label for="email">Email:</label>
        <input type="email" id="email" name="email"><br><br>
        <label for="phone">Phone:</label>
        <input type="tel" id="phone" name="phone"><br><br>
        <label for="plan">Plan:</label>
        <select id="plan" name="plan">
            <option value="basic">Basic</option>
            <option value="premium">Premium</option>
        </select><br><br>
        <input type="submit" value="Update Account Information">
    </form>

</body>
</html>
