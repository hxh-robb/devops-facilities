import jenkins.model.*;
import hudson.model.*;

// println Jenkins.instance.getItem('clean_builds');
println Jenkins.instance.getItems(TopLevelItem.class)
Jenkins.instance.copy(Jenkins.instance.getItem('setup_remote-devops-prereq_centos'), 'gou_ri_di');

println '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
println Jenkins.instance.getItems(TopLevelItem.class)

//println '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
//Jenkins.instance.remove(Jenkins.instance.getItem('gou_ri_di'))
//println Jenkins.instance.getItems(TopLevelItem.class)
