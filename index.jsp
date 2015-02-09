
<%@ page 
    contentType="text/html"
    pageEncoding="UTF-8"
    import="sql_connect.*"
    import="java.sql.*"
    import="java.util.*"     
%>
<!DOCTYPE html>
<html>

    
    <head>
            
<%
    Class.forName("com.mysql.jdbc.Driver");
    Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/mysql","root","root");
    Statement statement = connection.createStatement(); 
    ResultSet resultset = statement.executeQuery("select * from wishes ") ;
    int wishes = 0; 
%>
        <title>iWish Web Application For WWW Technologies</title>
        <link href="iwish.css" rel="stylesheet" type="text/css" />
        <script src='./jquery-2.1.1.min.js'></script>
        <script type="text/javascript" src='./jquery-2.1.1.min.js'></script><style type="text/css"></style>
        <meta content="text/html; charset=UTF-8">
        <Connector port="8080" URIEncoding="UTF-8"/>
               <script type="text/javascript">
            var WIDTH;
            var HEIGHT;
            var canvas;
            var con;
            var g;
            var isPaused = false;
            var pxs = new Array();
            var wish_titles = new Array();
            var wish_texts = new Array();
            var wish_username = new Array();
            var rint = 60;
            var intervalval;
            var isclicked = -1;
            var mouseX;
            var mouseY;

            $(document).ready(function(){
                var i=100;
                var pause = $('#pause');
                var put_wish =  $('#put_wish');
                var submit_wish =  $('#wish_submits');
                var pixie = $('#pixie');
                var $mountains = $('#mountains');
                var $grass = $('#grass');
                var $container = $('#container');
                var register = $('#register');
                var login = $('#login');
                var insides3 = $('.insides3');
                var insides4 = $('.insides4');
                $("#passwords2").keyup(validate);
                function validate() {
                    var password1= $("#passwords").val();
                    var password2 = $("#passwords2").val();

                    if(password1 == password2) {
                        $("#validate-status").text("Επιτυχής Επαλήθευση").css('color','#47FF36');
                    }
                    else {
                        $("#validate-status").text("Λανθασμένη Επαλήθευση").css('color','#FF3C3C');
                    }

                }
                window.onresize = function(e){
                    WIDTH = window.innerWidth;
                    HEIGHT = window.innerHeight-21;
                    canvas = document.getElementById('pixie');
                    $(canvas).attr('width', WIDTH).attr('height',HEIGHT);
                    $container.width(WIDTH).height(HEIGHT);
                    for(var i = 0; i < wishes; i++) {
                        pxs[i] = new Circle();
                        pxs[i].x = (pxs[i].s.random ? WIDTH*Math.random() : pxs[i].s.xdef);
                        pxs[i].y = (pxs[i].s.random ? HEIGHT*Math.random() : pxs[i].s.ydef);
                        pxs[i].reset();
                    }
                };
                WIDTH = window.innerWidth;
                HEIGHT = window.innerHeight-21;
                $container.width(WIDTH).height(HEIGHT);
                canvas = document.getElementById('pixie');
                $(canvas).attr('width', WIDTH).attr('height',HEIGHT);
                con = canvas.getContext('2d');
                con2 = canvas.getContext('2d');
                
<%
    while (resultset.next()){
%>
                pxs[<%= wishes %>] = new Circle();
                pxs[<%= wishes %>].x = <%= resultset.getString(1) %>;
                pxs[<%= wishes %>].y = <%= resultset.getString(2) %>;
                pxs[<%= wishes %>].reset();
                wish_titles[<%= wishes %>] = "<%=resultset.getString(3)%>";
                wish_texts[<%= wishes %>] = "<%=resultset.getString(4)%>";
                wish_username[<%= wishes %>] = "<%=resultset.getString(5)%>";
<%
    wishes++;
    }

%>
                intervalval = setInterval(draw,rint);

                pause.mousedown(function(){
                    isPaused = !isPaused; // flip the pause
                    if(isPaused){
                        put_wish.attr("disabled",true);
                        pause.text("Unpause");
                        clearInterval(intervalval);
                    }
                    else {
                        put_wish.attr("disabled",false);
                        pause.text("Pause");
                        intervalval = setInterval(draw,rint);
                    }
                });

                 put_wish.click(function() {
    
                         $('.insides5').fadeIn(1200).delay(800).fadeOut(1200);
                         pixie.css('cursor', 'pointer').click(function (event) {
                             $('.insides5').hide();
                             insides4.css('display','table');
                             var offset = $(this).offset();
                             isclicked = i;
                             pxs[i] = new Circle(i);
                             pxs[i].x = event.clientX - offset.left;
                             pxs[i].y = event.clientY - offset.top;
                             $('input[name="wish_x"]').val( pxs[i].x);
                             $('input[name="wish_y"]').val(pxs[i].y);
                             pxs[i].reset();
                             pixie.css('cursor', 'default');
                             i++;
                         });
                         pixie.click(function (event) {
                             var offset = $(this).offset();
                             var itsX = event.clientX - offset.left;
                             var itsY = event.clientY - offset.top;

                             for (var i = 0; i < pxs.length; i++) {
                                 if ((itsX - pxs[i].x <= 5) && (itsY - pxs[i].y <= 5) && (itsX - pxs[i].x >= -5) && (itsY - pxs[i].y >= -5)) {
                                     color = 'black';
                                     this.abort();
                                 }
                             }
                        });
                });

                $('.exit_1').click(function(){
                    $('.exit_1').parent().css('display','none');
                    isclicked = -1;

                });

                $('.exit_2').click(function(){
                    $('.exit_2').parent().css('display','none');
                    pxs[isclicked] = 0;
                    isclicked = -1;
                    i--;
                });

                pixie.click( function(event) {
                    var offset = $(this).offset();
                    var itsX = event.clientX - offset.left;
                    var itsY = event.clientY - offset.top;
                    mouseX = event.pageX;
                    mouseY = event.pageY;
                    for(var i = 0; i < pxs.length; i++) {
                        if ((itsX-pxs[i].x <=10)&&(itsY-pxs[i].y <=10)&&(itsX-pxs[i].x >=-10)&&(itsY-pxs[i].y >=-10)){
                            isclicked = i;
                            this.dx = 0;
                            this.dy = 0;
                            insides3.css('display','none');
                            $('#set_title').text(wish_titles[isclicked]);
                            $('#set_text').text(wish_texts[isclicked]);
                            $('#wish_username').text(wish_username[isclicked]);
                            if (window.innerWidth<700) {
                                insides3.css({
                                    'position' : 'absolute',
                                    left: ($(window).width() -insides3.outerWidth())/2,
                                    top: (insides3.outerHeight())/2
                                }).fadeIn(800).css('display', 'table');
                            }
                            else {
                                if ((window.innerWidth - mouseX > 333) && (window.innerHeight - mouseY > 333)) {
                                    insides3.css({
                                        'top': mouseY,
                                        'left': mouseX
                                    }).fadeIn(800).css('display', 'table');
                                }
                                else if ((window.innerWidth - mouseX > 333) && (window.innerHeight - mouseY < 333)) {
                                    insides3.css({
                                        'top': mouseY - insides3.width(),
                                        'left': mouseX
                                    }).fadeIn(800).css('display', 'table');
                                }
                                else if ((window.innerWidth - mouseX < 333) && (window.innerHeight - mouseY < 333)) {
                                    insides3.css({
                                        'top': mouseY - insides3.width(),
                                        'left': mouseX - insides3.width() - 20
                                    }).fadeIn(800).css('display', 'table');
                                }
                                else if ((window.innerWidth - mouseX < 333) && (window.innerHeight - mouseY > 333)) {
                                    insides3.css({
                                        'top': mouseY,
                                        'left': mouseX - insides3.width() - 20
                                    }).fadeIn(800).css('display', 'table');
                                }
                            }
                        }
                    }
                });
                submit_wish.click(function(){
                    $('.exit').parent().css('display','table');

                });
                register.click( function() {
                    login.attr("disabled",true);
                    register.attr("disabled",true);
                 });
                login.click( function() {
                    login.attr("disabled",true);
                    register.attr("disabled",true);
                });
                $('#log_back').click( function() {
                    register.attr("disabled",false);
                    login.attr("disabled",false);
                });
                $('#reg_back').click( function() {
                    register.attr("disabled",false);
                    login.attr("disabled",false);
                });

            });

            function draw() {
                con.clearRect(0,0,WIDTH,HEIGHT);
                for(var i = 0; i < pxs.length; i++) {
                    pxs[i].draw();
                    if (isclicked==i) {
                        pxs[i].r =30;
                        pxs[i].rt = 1;

                        continue;
                    }
                    pxs[i].fade();
                    pxs[i].move();
                }
            }

            function Circle() {
                this.s = {ttl:8000, xmax:5, ymax:2, rmax:10, rt:1, xdef:960, ydef:540, xdrift:4, ydrift: 4, random:true, blink:true};

                this.reset = function() {
                    this.r = ((this.s.rmax-1)*Math.random()) + 5;
                    this.dx = (Math.random()*this.s.xmax) * (Math.random() < .5 ? -1 : 1);
                    this.dy = (Math.random()*this.s.ymax) * (Math.random() < .5 ? -1 : 1);
                    this.hl = (this.s.ttl/rint)*(this.r/this.s.rmax);
                    this.rt = Math.random()*this.hl;
                    this.s.rt = Math.random()+3;
                    this.stop = Math.random()*.2+.4;
                    this.s.xdrift *= Math.random() * (Math.random() < .5 ? -1 : 1);
                    this.s.ydrift *= Math.random() * (Math.random() < .5 ? -1 : 1);
                }

                this.fade = function() {
                    this.rt += this.s.rt;
                }

                this.draw = function() {
                    if(this.s.blink && (this.rt <= 0 || this.rt >= this.hl)) this.s.rt = this.s.rt*-1;
                    else if(this.rt >= this.hl) this.reset();
                    var newo = 1-(this.rt/this.hl);
                    con.beginPath();
                    con.arc(this.x,this.y,this.r,0,Math.PI*2,true);
                    con.closePath();
                    var cr = this.r*newo;
                    g = con.createRadialGradient(this.x,this.y,0,this.x,this.y,(cr <= 0 ? 1 : cr));
                    g.addColorStop(0.0, 'rgba(255,255,255,'+newo+')');
                    g.addColorStop(this.stop, 'rgba(77,101,181,'+(newo*.6)+')');
                    g.addColorStop(1.0, 'rgba(77,101,181,0)');
                    con.fillStyle = g;
                    con.fill();

                }

                this.move = function() {
                    if (this.r == 30) this.r = ((this.s.rmax-1)*Math.random()) + 1;
                    this.x += (this.rt/this.hl)*this.dx;
                    this.y += (this.rt/this.hl)*this.dy;
                    if(this.x > WIDTH || this.x < 0) this.dx *= -1;
                    if(this.y > HEIGHT || this.y < 0) this.dy *= -1;
                }

                this.getX = function() { return this.x; }
                this.getY = function() { return this.y; }
            }
        </script>
</head>
    <body>


          <div id="widther">
            <button id="pause" value="pause">pause</button>
<%
    out.write("Καλώς Ήλθες, ");	
    UserBean username = (UserBean)(session.getAttribute("currentSessionUser"));
    if(username!=null){
        out.write(username.getFirstName()+" "+username.getLastName()+"!");      
%>         
        <button id="put_wish" value="hit me">Enter Wish</button>
        <form  style="float:right;" action="LogoutServlet">
            <input type="submit" value="Logout" />
        </form>
<% 
    }
    else {
        out.write("Για Είσοδο Πάτα");    
%>
        <button style="float:right;" id="register" value="hit me" onclick="$('.insides').css('display','table');">Register</button>
        <button style="float:right;" id="login" value="hit me" onclick="$('.insides2').css('display','table');">Login</button>
<%
    }
%>
         </div>
        <div id="container">
            <canvas id="pixie"> </canvas>
            <div class="insides">
                <form method="post" action="Register">

                    <div class="Registering">
                        <div class="reg_head">Συμπληρώστε Τη Φόρμα <br> Για Εγγραφή</div>
                        <input class="reg_inpts" type="text" maxlength="15" style="color:#525252;" name="FirstName" id="name"
                               placeholder="Όνομα" onfocus="this.placeholder = ''" onblur="this.placeholder = 'Όνομα'" >
                        <label for="name"></label>
                        <input class="reg_inpts" type="text" maxlength="20" style="color:#525252;" name="LastName" id="surname"
                               placeholder="Έπίθετο" onfocus="this.placeholder = ''" onblur="this.placeholder = 'Έπίθετο'" >
                        <label for="surname"></label>
                        <input class="reg_inpts" type="text" maxlength="30" style="color:#525252;" name="Email" id="mails"
                               placeholder="Διεύθυνση e-mail" onfocus="this.placeholder = ''" onblur="this.placeholder = 'Διεύθυνση e-mail'" >
                        <label for="mails"></label>
                        <input class="reg_inpts" type="text" maxlength="15" style="color:#525252;" name="usermame" id="usernames"
                               placeholder="Ψευδώνυμο" onfocus="this.placeholder = ''" onblur="this.placeholder = 'Ψευδώνυμο'" >
                        <label for="usernames"></label>
                        <input class="reg_inpts" type="password" maxlength="15" style="color:#525252;" name="password" id="passwords"
                               placeholder="Κωδικός" onfocus="this.placeholder = ''" onblur="this.placeholder = 'Κωδικός'" >
                        <label for="passwords"></label>
                        <input class="reg_inpts" type="password" maxlength="15" style="color:#525252;" name="password2" id="passwords2"
                               placeholder="Επαλήθευση Κωδικού" onfocus="this.placeholder = ''" onblur="this.placeholder = 'Επαλήθευση Κωδικού'" >
                        <label for="passwords2"></label>
                        <div id="validate-status"></div>
                        <div class="centerer">
                            <button class="buttons" type="button" style="color:#525252;" onclick="$('.insides').css('display','none');" id="reg_back">Επιστροφή</button>
                            <input class="buttons" type="submit" style="color:#525252;" id="reg_submits">
                            <label for="reg_submits"></label>
                        </div>
                        <div class="reg_foot">
                            Έχετε ήδη Λογαριασμό? Πατήστε <a href="">Εδώ!</a>
                        </div>
                    </div>
                </form>
            </div>
            <div class="insides2">
                <form  action="LoginServlet">
                    <div class="Registering">
                        <div class="reg_head">Δώστε Στοιχεία Για Είσοδο</div>

                        <input class="reg_inpts" type="text" maxlength="15" style="color:#525252;" name="username" id="log_usernames"
                               placeholder="Ψευδώνυμο" onfocus="this.placeholder = ''" onblur="this.placeholder = 'Ψευδώνυμο'" >
                        <label for="log_usernames"></label>
                        <input class="reg_inpts" type="password" maxlength="15" style="color:#525252;" name="password" id="log_passwords"
                               placeholder="Κωδικός" onfocus="this.placeholder = ''" onblur="this.placeholder = 'Κωδικός'" >
                        <label for="log_passwords"></label>

                        <div class="centerer">
                            <button class="buttons" type="button" style="color:#525252;" onclick="$('.insides2').css('display','none');" id="log_back">Επιστροφή</button>
                            <input class="buttons" type="submit" style="color:#525252;" id="log_submits">
                            <label for="log_submits"></label>
                        </div>
                        <div class="reg_foot">
                           Δεν έχετε Λογαριασμό? Πατήστε <a href="">Εδώ!</a>
                        </div>
                    </div>
                </form>
            </div>
            <div class="insides3">
                <button class="exit_1">&#x2716;</button>
                <div class="Registering">
                    <div class="user_id"  id="wish_username">Lorenzo's Wish:</div>
                    <div class="wish_title" id="set_title">Αγαπητέ Νίκο και Ευγενεία.</div>
                    <div class="wish_text" id="set_text">Οι άγιες μέρες που έρχονται ας φέρουν την ευτυχία στο σπίτι σας και ο καινούργιος χρόνος ας είναι γεμάτος όμορφες στιγμές και πολλά χαμόγελα!</div>
                    <div class="reg_foot">
                        Σύντομα και σχόλια!! :)
                    </div>
                </div>
            </div>
            <div class="insides4">
                <button class="exit_2">&#x2716;</button>
                <div class="Registering">
                    <div class="user_id">asdasd</div>
                    <form id="get_wish" method="post" action="EnterWishData">
                        <input type="hidden" name="wish_x" value="">
                        <input type="hidden" name="wish_y" value="">
                        <div class="wish_title">
                            <textarea class="reg_inpts" maxlength="50" rows="3" style="color:#525252;" name="wish_title" form="get_wish"
                                   placeholder="Τίτλος Ευχής" onfocus="this.placeholder = ''" onblur="this.placeholder = 'Τίτλος Ευχής'" ></textarea>
                        </div>
                        <div class="wish_text">
                            <textarea class="reg_inpts" maxlength="1024" size="50" rows="15" style="color:#525252;" name="wish_text" form="get_wish"
                                      placeholder="Κείμενο Ευχής" onfocus="this.placeholder = ''" onblur="this.placeholder = 'Κείμενο Ευχής'" ></textarea>
                        </div>
                        <input type="hidden" name="username" value="Vincent">

                        <div class="reg_foot">
                            <button class="buttons" type="button" style="color:#525252;" onclick="$('.insides4').css('display','none');" id="wish_back">Επιστροφή</button>
                            <input class="buttons" type="submit" style="color:#525252;" id="wish_submits">
                            <label for="wish_submits"></label>
                        </div>
                    </form>
                </div>
            </div>
            <div class="insides5">Ρίξτε Μία Ευχή Πατώντας στον Ουρανό!!</div>
        </div>

    </body>

</html>