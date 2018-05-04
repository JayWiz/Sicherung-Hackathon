<!DOCTYPE html>
<html lang="en">

<head>
    <title>Zeppelin SmartFactory</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">

    <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">


    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
    <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
    <link rel="stylesheet" href="main.css">



</head>

<body>
    <nav class="navbar navbar-inverse">
        <div class="container-fluid">
            <ul class="nav navbar-nav">
                <li><a href="index.html">Start</a></li>
                <li><a href="support.php">support</a></li>
                <li><a href="about.html">about us</a></li>
                <li><a href="impressum.html">impressum</a></li>
                <li class="active"><a href="controlling.php">controlling</a></li>
            </ul>
        </div>
    </nav>

    <div class="container">
        <div class="row">
            <div class="col-md-12">
                <h1>Controlling</h1>
            </div>
        </div>
        <div class="row">
            <div class="col-md-12">
                <h3>Motorsteuerung</h3>
            </div>
        </div>


        <div class="row">
            <div class="slidecontainer">

                <p>Custom range slider:</p>
                <input type="range" min="1" max="150" value="50" class="slider" id="myRange">
                <p id="demo">12</p>
            </div>
        </div>
    </div>
        <script>
            console.log("inside script");
            var slider = document.getElementById("myRange");
            var output = document.getElementById("demo");
            output.innerHTML = slider.value;
           
           

            slider.oninput = function() {
                output.innerHTML = this.value;
                window.location.href = "?myVar="+ slider.value;
                
               } 
            
            </script>
    
               <?php
    
                if (isset($_GET['myVar'])){
                    echo "yes";
                    $myVar = $_GET['myVar'];
                    echo $myVar;
                    $myfile = fopen("aslan.txt", "w") or die("Unable to open file!");
                    fwrite($myfile, $myVar);
                    close($myfile);
                    
                } else {
                    echo "no";
                }
    
    
    
               //$actual_link = $_SERVER['REQUEST_URI']
                //preg_match_all('?myVar=(.+?)' $actual_link, $matches); 
                print($matches);
                $rest = substr($matches, 5,7);  
                
                //$myfile = fopen("aslan.txt", "w") or die("Unable to open file!");
                 
                //fwrite($myfile, $rest);
               
              
                fclose($myfile);
                ?> 
                

        





</body>
</html>
