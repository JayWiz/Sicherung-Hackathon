<!DOCTYPE html>
<html lang="en">

<head>
    <title>Smart Factory</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
    <script src="https://code.jquery.com/jquery-1.9.1.min.js"></script>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
    <link rel="stylesheet" href="main.css">
    <script>
        $(document).ready(function() {
            console.log("test123");
            $("#magic").append('<form><div class="form-group"><label for="name">Your Name</label><input type="text" class="form-control inblack" id="name" placeholder="your name"></div><div class="form-group"><label for="email">E-Mail</label><input type="email" class="form-control inblack" id="email" placeholder="E-Mail"></div><div class="form-group"><label for="reason">Reason</label><input type="text" class="form-control inblack" id="reason" placeholder="reason"></div><div class="form-group"><label for="comment">Comment:</label><textarea class="form-control inblack" rows="5" id="comment"></textarea></div><button type="submit" class="btn btn-primary inblack">Submit</button></form>');
            $("#magic").fadeIn(3500);
        });

    </script>

</head>

<body class="backblack">

    <nav class="navbar navbar-inverse">
        <div class="container-fluid">
            <ul class="nav navbar-nav">
                <li><a href="index.html">Start</a></li>
                <li class="active"><a href="support.php">Support</a></li>
                <li><a href="about.html">About us</a></li>
                <li><a href="impressum.html">Impressum</a></li>
                  <li><a href="controlling.php">Controlling</a></li>
            </ul>
        </div>
    </nav>
    <div class="container">
        <h1 style="font-weight:bolder;">Contact Us</h1>
        <div id="magic" style="display:none">
            
        </div>
    </div>

    <div class="footer">
        <p>©2018 SpecterWho</p>
    </div>
</body>

</html>
