import jenkins.model.*;
import hudson.model.*;

def jenkins = Jenkins.instance;

// def job = jenkins.getItemByFullName('template_workbench-remote-deployment');
def job = jenkins.getItemByFullName('concrete');
def paramDefProp = job.getProperty(ParametersDefinitionProperty.class);
def paramDef = paramDefProp.getParameterDefinition('CONFIGS');
// paramDef.setDefaultValue('mamamia');
paramDefProp.parameterDefinitions.remove(paramDef);
paramDef.setDefaultValue('1111111');
paramDefProp.parameterDefinitions.add(paramDef);

/*
job.builders.each{
  builder ->
  // println builder.class.simpleName
  println builder.delegate.delegate.publishers.each{
    publisher ->
    publisher.configName = 'jenkins@192.168.0.43'
    // println publisher.configName
  }
  println '================================='
}
*/

// jenkins.addView(new ListView('plansoft-prod'))


import org.kohsuke.stapler.StaplerRequest
import org.kohsuke.stapler.StaplerResponse

Jenkins.get().getView('All').doSubmitDescription([ getParameter: { return """
<h3>Welcome to datenkollektiv Jenkins</h3>
This Jenkins builds all required components to power <a href="https://planets.datenkollektiv.de/">Planets</a>
"""; }] as StaplerRequest, [ sendRedirect: { return; } ] as StaplerResponse)
