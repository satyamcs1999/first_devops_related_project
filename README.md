__<h1>Integration of GitHub,Jenkins and Docker (Web Page Deployment)</h1>__

![Docker_Jenkins](https://cdn-images-1.medium.com/max/1000/1*GxmTEWTkGF8mqoATocSDrg.png)<br>

<br><br>
<p><b>Technologies Used</b> : Git and GitHub, Jenkins, Docker</p><br>
<p><b>Concepts Used</b> : Tunneling, PAT (Port Address Translation)</p><br>
<p><b>Operating System</b> : Redhat Linux 8, Windows 10</p><br>

<p>In this task, I've created a basic end-to-end automation of Web Hosting using the CI/CD pipeline involving DevOps Tools like Git and GitHub for <b>Continuous Development (CD)</b> , Jenkins for <b>Continuous Integration (CI)</b> and Docker for quick OS provision that provides environment for our Web Hosting.</p><br>

<h2>Setting up GitHub Repository</h2>
<p>Initially , we have to set up our local repository in our respective local machine and it could be set up using <b>Git Bash</b>, in our case , we have set up folder named <b>"automation"</b> holding the web pages to be hosted. The commands to set up the same are as follows :</p>

```shell
mkdir automation/

cd automation/

vim index.html     # you can use notepad or any other text editor
```

<br>
<p>Before creating our own local repository , we first need to create an empty repository in GitHub , after creating , convert the existing directory i.e. "automation" and push the web page <b>"index.html"</b> to your GitHub Repository using the following commands :</p>

```shell
git init                                

git add * 

git commit -m "Urban Dictionary(only HTML)"

git remote add origin https://github.com/satyamcs1999/devops_assign.git

git push -u origin master
```

<br>
<p>For pushing the web page to our <b>master</b> branch in GitHub repository , we need to specify "<b>git push -u origin master</b>(only during first time) or <b>git push</b>", but by using the the <b>hooks/</b> directory within <b>.git/</b>, we can modify it in such a way that it would commit and also push without specifying any separate command for the same, first of all we need to create a file named <b>"post-commit"</b> and script to be included are as follows :</p>

```shell
vim post-commit

#!/bin/bash

git push
```

<br>
<p>We can also create new branch that facilitates multiple developers to work on same code simultaneously , the commands for the same are :</p>

```shell
git branch dev1      # only creates a new branch "dev1"

git checkout -b dev1   # creates as well as goes to branch "dev1"
```

<br>
<p>The commands for adding , committing are same as previous case i.e. :</p>

```shell
git add *

git commit -m "Urban Dictionary(with CSS)"

git push -u origin dev1
```

<br>
<p>The difference between this branch and the previous case i.e. "<b>master</b>" branch is that it doesn't require the addition of remote to the Git repo ,and a minor change in the initial push command i.e. instead of "master", we specify "<b>dev1</b>" here.</p>
<p>After this setup , our GitHub would like this :</p>

![GitHub_repo_1](https://cdn-images-1.medium.com/max/1000/1*XYd09dPcknH96e-KW_9KZQ.png)

![GitHub_repo_2](https://cdn-images-1.medium.com/max/1000/1*T_1aLwERCUCcizaYr3IUpg.png)

<br><br>
<h2>Setting up and execution of jobs in Jenkins</h2>
<h3>First Job (Testing)</h3>
<p>We create two jobs namely "<b>job1_assign</b>" which is an upstream project , whereas , the second one is "<b>job1_assign_1</b>" which is a downstream project , here , the downstream one only builds/executes , if the build of the upstream one is stable.</p>
<p>The upstream project checks using Poll SCM if the "<b>dev1</b>" branch in GitHub repository has any change implemented every minute, if yes , it pulls the changes to its workspace , after this process , it checks if a directory "<b>codetest</b>" exist in the root directory, if yes , it copies the file from workspace to that directory , and if directory doesn't exist , it creates one of same name and copies the file to that directory. The code for the same is as follows :</p>

![job1_assign_code](https://cdn-images-1.medium.com/max/1000/1*FI0jnhomVJ-KROB23FjbwA.png)

<br>
<p>Here , the downstream project pushes the code in codetest directory to the <b>Docker</b> container named "<b>testing</b>" for testing purpose , the docker image used for creating the same is <b>httpd</b> Image. If the container already exist, it removes the existing container and creates a new container of same name and using same image since it is a good practice to create a fresh environment every time for testing , and if it doesn't exist already , then it directly creates a new container of same name and using same image. Here , while creating the testing container, we apply the concept of mounting i.e. we link two directories such that change in one gets reflected in the other directory, it eliminates the process of copying from one file to another as it is quite time consuming in nature.</p>
<p>In our case , we link codetest (which consist our web page to be tested) to <b>/usr/local/apache2/htdocs/</b> in httpd (it is responsible for hosting our web page), also we haven't applied <b>PAT (Port Address Translation)</b> as testing needs to be performed in isolated manner .</p>

![job1_assign_1_code](https://cdn-images-1.medium.com/max/1000/1*InafyQXS3M4V_Nb8-z-7Dg.png)

<br>
<p>After the successful execution of first job , we can access the site in our Redhat OS.</p>

![output](https://cdn-images-1.medium.com/max/1000/1*kXApYuBR7YtKiYj-aOgsjA.png)

<br><br>
<h3>Second Job (Production)</h3>
<p>Similar to previous job, we create two jobs namely "<b>job2_assign</b>" which is an upstream project , whereas , the second one is "<b>job2_assign_1</b>" which is a downstream project , here , the downstream one only builds/executes , if the build of the upstream one is stable.</p>
<p>The upstream project checks using Poll SCM if the "<b>master</b>" branch in GitHub repository has any change implemented every minute, if yes , it pulls the changes to its workspace , after this process , it checks if a directory "<b>production_code</b>" exist in the root directory, if yes , it copies the file from workspace to that directory , and if directory doesn't exist , it creates one of same name and copies the file to that directory. The code for the same is as follows :</p>

![job2_assign_code](https://cdn-images-1.medium.com/max/1000/1*Uz63BvKAngabjwi-mptqHQ.png)

<br>
<p>Here , the downstream project pushes the code in codetest directory to the <b>Docker</b> container named "<b>production</b>" for production purpose , the docker image used for creating the same is <b>httpd</b> Image. If the container already exist, it returns a message that says '<b>already running</b>' , and if it doesn't exist already , then it directly creates a new container of same name and using httpd image. Similar to previous job, we apply the concept of mounting , also we apply the concept of <b>PAT (Port Address Translation)</b> that expose the private IP of the container to the public so that it could be accessed from Windows in this case.</p>
<p>Similar to previous case , we link production_code(which consist our web page for production) to <b>/usr/local/apache2/htdocs/</b> in httpd (it is responsible for hosting our web page).</p>

![job2_assign_1_code](https://cdn-images-1.medium.com/max/1000/1*E1v5947NJFzj_N4pyHVT8w.png)

<br>
<p>After successful execution of second job , we can access our web page from Windows , but for it to be accessible by client from anywhere , we perform <b>Tunneling</b> using <b>ngrok</b> which provides a public URL for specified port for limited amount of time.</p>

![ngrok](https://cdn-images-1.medium.com/max/1000/1*jktswxX4Qe9FasioxMmtrg.png)

![output](https://cdn-images-1.medium.com/max/1000/1*AE8TU3Z5UJT9Ec9eZ0EqnA.png)

<br><br>
<h3>Third Job (Merging)</h3>
<p>After execution of our <b>First Job</b> , we manually inspect that the web page generated satisfies the requirement , if yes , we perform <b>remote trigger</b> which starts the execution of <b>Third Job</b>, this job merges the code present in "<b>dev1</b>" branch to "master" branch , and since <b>Second Job</b> detects changes in the "master" branch , it pulls the changes , copies it to the production_code directory and accordingly pushes the changes to the production container, we observe the change accordingly.</p><br>
<p><b>From this</b></p>

![from_this](https://cdn-images-1.medium.com/max/1000/1*AE8TU3Z5UJT9Ec9eZ0EqnA.png)

<br>
<p><b>To this</b></p>

![to_this](https://cdn-images-1.medium.com/max/1000/1*vf1mzcXM4E-VYLXqpCJKFA.png)

<br>
<p align="center"><b>. . .</b></p><br>
<h4>Note :</h4>

<ol>
  <li>For providing sudo access to Jenkins , we provide root access to '<b>jenkins</b>' user by first accessing <b>gedit /etc/sudoers</b> from home directory and also makes it passwordless for easier access by Jenkins.</li><br>
  
  ![sudoers](https://cdn-images-1.medium.com/max/1000/1*tecmC2MZUpmRSQj-TwHZPw.png)
  
  <br>
  <li>For launching Jenkins in Windows , first executes these set of commands</li><br>
  
  ```shell
  systemctl stop firewalld

  systemctl start jenkins

  ifconfig  # for checking IP
  ```
  
  <br>
  <p>Default port number for Jenkins is <b>8080</b>, it can be accessed from Windows using:</p><br>
  <p><b>http://[IP Address]:8080</b></p><br>
  <p>Screen would look something like this:</p><br>
  
  ![Jenkins_home_screen](https://cdn-images-1.medium.com/max/1000/1*d50gfPsrtnyuyy3jbmKsXQ.png)
  
  <br>
  <li>For setting up ngrok, execute these commands in Linux OS:</li><br>
  
  ```shell
  unzip ngrok.tar.gz

  ./ngrok http 8081
  ```
  
  <br>
  <li> <b>[Update]</b> : In GitHub, <b>master</b> branch has been renamed to <b>main</b> branch, therefore before pushing the code to the GitHub repository, branch could be switched from master to main using the command mentioned below:</li><br>
  
  ```shell
  git branch -M main
  ```
  
</ol><br><br>

<h2>Thank You :smiley:<h2>
<h3>LinkedIn Profile</h3>
https://www.linkedin.com/in/satyam-singh-95a266182

<h2>Link to the repository mentioned above</h2>
https://github.com/satyamcs1999/devops_assign.git






