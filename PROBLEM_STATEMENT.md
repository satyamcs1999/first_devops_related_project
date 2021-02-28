__<h1>Problem Statement</h1>__

<h3>JOB 1</h3>
<p>If Developer push to dev branch then Jenkins will fetch from dev and deploy on dev-docker environment.</p><br>

<h3>JOB 2</h3>
<p>If Developer push to master branch then Jenkins will fetch from master and deploy on master-docker environment, both dev-docker and master-docker environment are on different docker containers.</p><br>

<h3>JOB 3</h3>
<p>Manually the QA team will check (test) for the website running in dev-docker environment. If it is running fine then Jenkins will merge the dev branch to master branch and trigger #job 2.</p>
