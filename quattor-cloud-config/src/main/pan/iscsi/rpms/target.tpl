# ${BUILD_INFO}
#
# Created as part of the StratusLab project (http://stratuslab.eu)
#
# Copyright (c) 2010-2011, Centre National de la Recherche Scientifique
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

unique template iscsi/rpms/target;

#'/software/packages' = pkg_repl('iscsitarget','1.4.20.2-1','x86_64');
'/software/packages' = pkg_repl('scsi-target-utils','1.0.1-3.fc13','x86_64');
#'/software/packages' = pkg_repl('kmod-iscsitarget','1.4.20.2-1_2.6.18_194.32.1.el5','x86_64');
#'/software/packages' = pkg_repl('kmod-iscsitarget','1.4.20.2-1_2.6.18_238.1.1.el5','x86_64');

include { 'config/stratuslab/iscsi-target' };
