import jenkins.model.*;
import hudson.model.*;
import org.kohsuke.stapler.StaplerRequest;
import org.kohsuke.stapler.StaplerResponse;

def jenkins = Jenkins.instance;

def name = build.buildVariables.get('NAME');
def desc = build.buildVariables.get('DESC');
def server = build.buildVariables.get('SERVER');
def serverType = build.buildVariables.get('SERVER_TYPE');
def source = build.buildVariables.get('SORUCE');
def gitBranch = build.buildVariables.get('GIT_BRANCH');

// Check the fucking parameters
def pass = (name ==~ /[a-z0-9\-]+/);
if (! pass) {
  println '无效项目名称:项目名称不允许为空且只允许输入半角数字/小写英文/减号(用作分隔)';
  return 1;
}

if ( server == 'NONE' ) {
  println '无效远端服务器:请使用[setup_remote-devops-prereq_centos]创建远端服务器配置';
  return 1;
}

if ( null == gitBranch || '' == gitBranch ) {
  gitBranch = 'master';
}

def view = serverType + ' - ' + name;
def devopsId = serverType.toLowerCase() + '_' + name;

if ( serverType == 'DEV' ) {
  view = "$view($gitBranch)";
  devopsId = devopsId + '_' + gitBranch;
}

println '~~~~~~~~~~ 本次创建参数信息 ~~~~~~~~~~';
println "DevOps ID : [$devopsId]";
println "DevOps任务所在页签 : [$view]";
println "项目名称 : [$name]";
println "远端服务器 : [$server]";
println "服务器类型 : [$serverType]";
println "构建来源 : [$source]";
if ( serverType == 'DEV' ) {
  println "git分支 : [$gitBranch]";
}
println '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~';


def jobsView = jenkins.getView(view);
if( null == jobsView ) {
  jobsView = new ListView(view)
  println '~~~~~~~~~~ 添加页签 : [$view] ~~~~~~~~~~';
  jenkins.addView(jobsView);
}

/*
// testing
if ( jobsView.getItems().isEmpty() ) {
  jobsView.add(jenkins.getItemByFullName('clean_builds'));
}
*/

def jobsViewButtonList = jobsView.getColumns();
if( jobsViewButtonList.size() > 6) {
  def newButtonList = [
    jobsViewButtonList.get(6),
    jobsViewButtonList.get(0),
    jobsViewButtonList.get(2),
    jobsViewButtonList.get(3),
    jobsViewButtonList.get(4),
    jobsViewButtonList.get(5)
  ];
  jobsView.setColumns(newButtonList);
}
jobsView.doSubmitDescription(
  [getParameter: {return "<h3>" + desc + "</h3>";}] as StaplerRequest, 
  [sendRedirect: {return;}] as StaplerResponse
)

/*
newButtonList.add(jobsViewButtonList.get(0));
newButtonList.add(jobsViewButtonList.get(1));
newButtonList.add(jobsViewButtonList.get(2));
newButtonList.add(jobsViewButtonList.get(3));
newButtonList.add(jobsViewButtonList.get(4));
newButtonList.add(jobsViewButtonList.get(5));

def jobsViewButtonList = jobsView.getColumns();
def weatherButton = jobsViewButtonList.get(1);
def buildButton = jobsViewButtonList.get(jobsViewButtonList.size()-1);

jobsViewButtonList.remove(weatherButton.descriptor);
jobsViewButtonList.remove(buildButton.descriptor);
*/
