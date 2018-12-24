$msgBoxInput0 = [System.Windows.MessageBox]::Show('Please verify the Old username prior to proceeding. Once finished, close the document and press ENTER to continue','Please Verify')
start $env:userprofile\AppData\Roaming\VanDyke\Config\SSH2.ini
Read-Host 'Press Enter to continue'



Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

 $form = New-Object “System.Windows.Forms.Form”;
 $form.Width = 500;
 $form.Height = 150;
 $form.Text = $title;
 $form.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen;

##############Define text label1
 $textLabel1 = New-Object “System.Windows.Forms.Label”;
 $textLabel1.Left = 25;
 $textLabel1.Top = 15;
 $textLabel1.Text = 'Old User Profile';

##############Define text label2

 $textLabel2 = New-Object “System.Windows.Forms.Label”;
 $textLabel2.Left = 25;
 $textLabel2.Top = 50;
 $textLabel2.Text = 'New User Profile';


############Define text box1 for input
 $textBox1 = New-Object “System.Windows.Forms.TextBox”;
 $textBox1.Left = 150;
 $textBox1.Top = 10;
 $textBox1.width = 200;

############Define text box2 for input

 $textBox2 = New-Object “System.Windows.Forms.TextBox”;
 $textBox2.Left = 150;
 $textBox2.Top = 50;
 $textBox2.width = 200;

#############Define default values for the input boxes
 $defaultValue = “first.m.last”
 $textBox1.Text = $defaultValue;
 $textBox2.Text = $defaultValue;

#############define button
 $button = New-Object “System.Windows.Forms.Button”;
 $button.Left = 360;
 $button.Top = 85;
 $button.Width = 100;
 $button.Text = “Continue”;

############# This is when you have to close the form after getting values
 $eventHandler = [System.EventHandler]{
 $textBox1.Text;
 $textBox2.Text;
 $form.Close();};
 $button.Add_Click($eventHandler) ;

#############Add controls to all the above objects defined
 $form.Controls.Add($button);
 $form.Controls.Add($textLabel1);
 $form.Controls.Add($textLabel2);
 $form.Controls.Add($textBox1);
 $form.Controls.Add($textBox2);
 $ret = $form.ShowDialog();


############SETS SSH2.INI DIRECTORY POINTER TO USERS FILE DIRECTORY
    Get-ChildItem $env:userprofile\AppData\Roaming\VanDyke\Config\SSH2.ini |
        foreach {
            (Get-Content $_) -replace $textBox1.Text,$textBox2.Text |
                Set-Content $_
                    }
############SETS ALL SESSION INIs TO THE USERS FILE DIRECTORY POINTER
    Get-ChildItem $env:userprofile\AppData\Roaming\VanDyke\Config\Sessions -Recurse -Include *.ini |
    select -expand fullname |
        foreach {
            (Get-Content $_) -replace $textBox1.Text,$textBox2.Text |
                Set-Content $_
                    }
############ACS to RSA Account username migration

 $form1 = New-Object “System.Windows.Forms.Form”;
 $form1.Width = 500;
 $form1.Height = 150;
 $form1.Text = $title;
 $form1.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen;

##############Define text label3
 $textLabel3 = New-Object “System.Windows.Forms.Label”;
 $textLabel3.Left = 25;
 $textLabel3.Top = 15;
 $textLabel3.Text = 'Old ACS/RSA Account';

##############Define text label4

 $textLabel4 = New-Object “System.Windows.Forms.Label”;
 $textLabel4.Left = 25;
 $textLabel4.Top = 50;
 $textLabel4.Text = 'New ACS/RSA Account';


############Define text box3 for input
 $textBox3 = New-Object “System.Windows.Forms.TextBox”;
 $textBox3.Left = 150;
 $textBox3.Top = 10;
 $textBox3.width = 200;

############Define text box4 for input

 $textBox4 = New-Object “System.Windows.Forms.TextBox”;
 $textBox4.Left = 150;
 $textBox4.Top = 50;
 $textBox4.width = 200;

#############Define default values for the input boxes
 $defaultValue = “first.m.last.acs”
 $defaultValue1 = "first.m.last.rsa"
 $textBox3.Text = $defaultValue;
 $textBox4.Text = $defaultValue1;

#############define button
 $button = New-Object “System.Windows.Forms.Button”;
 $button.Left = 360;
 $button.Top = 85;
 $button.Width = 100;
 $button.Text = “Continue”;

############# This is when you have to close the form after getting values
 $eventHandler = [System.EventHandler]{
 $textBox3.Text;
 $textBox4.Text;
 $form1.Close();};
 $button.Add_Click($eventHandler) ;

#############Add controls to all the above objects defined
 $form1.Controls.Add($button);
 $form1.Controls.Add($textLabel3);
 $form1.Controls.Add($textLabel4);
 $form1.Controls.Add($textBox3);
 $form1.Controls.Add($textBox4);
 $ret = $form1.ShowDialog();

     Get-ChildItem $env:userprofile\AppData\Roaming\VanDyke\Config\Sessions -Recurse -Include *.ini |
    select -expand fullname |
        foreach {
            (Get-Content $_) -replace $textBox3.Text,$textBox4.Text |
                Set-Content $_
                    }



#############Some accounts fail to properly change the .acs to .rsa- This corrects that issue and clears any saved passwords.
$Old = 'Session Password Saved"=00000001'
$Clear = 'Session Password Saved"=00000000'
$ACS = '.acs'
$RSA = '.rsa'


get-childitem $env:userprofile\AppData\Roaming\VanDyke\Config\Sessions -recurse -include *.ini | 
 select -expand fullname |
  foreach {

            (Get-Content $_) -replace $Old,$Clear |
             Set-Content $_
            (Get-Content $_) -replace $ACS,$RSA |
             Set-Content $_
            }


##########Migration Verification
$msgBoxInput0 = [System.Windows.MessageBox]::Show('Please verify that your information copied correctly. Specifically, verify the SFTP Tab Local directory is correct and that your username is correct (with the correct file extension. Select any .ini file to verify. Once finished, close the file and the sub-directory window)')
start $env:userprofile\AppData\Roaming\VanDyke\Config\Sessions
Read-Host 'Press ENTER to continue'

$msgBoxInput1 = [System.Windows.MessageBox]::Show('Are the specified username and file directories correct?','Please Verify','YesNo','Error')
    switch (msgBoxInput1) {
        'Yes' {
            Exit
            }
        'No' {
        start $env:userprofile\AppData\Roaming\VanDyke\Config\Sessions
        }}
        $msgBoxInput0 = [System.Windows.MessageBox]::Show('Please verify the username listed in the ini file (the username entered in the next process needs to be an exact match) Once done, close the ini file and the directory window')
        read-host 'Press ENTER to continue'
        
        
 $form2 = New-Object “System.Windows.Forms.Form”;
 $form2.Width = 500;
 $form2.Height = 150;
 $form2.Text = $title;
 $form2.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen;

##############Define text label5
 $textLabel5 = New-Object “System.Windows.Forms.Label”;
 $textLabel5.Left = 25;
 $textLabel5.Top = 15;
 $textLabel5.Text = 'Incorrect Username';

##############Define text label6

 $textLabel6 = New-Object “System.Windows.Forms.Label”;
 $textLabel6.Left = 25;
 $textLabel6.Top = 50;
 $textLabel6.Text = 'Correct Username';


############Define text box5 for input
 $textBox5 = New-Object “System.Windows.Forms.TextBox”;
 $textBox5.Left = 150;
 $textBox5.Top = 10;
 $textBox5.width = 200;

############Define text box6 for input

 $textBox6 = New-Object “System.Windows.Forms.TextBox”;
 $textBox6.Left = 150;
 $textBox6.Top = 50;
 $textBox6.width = 200;

#############Define default values for the input boxes
 $defaultValue = “first.m.last.rsa”
 $textBox5.Text = $defaultValue;
 $textBox6.Text = $defaultValue;

#############define button
 $button = New-Object “System.Windows.Forms.Button”;
 $button.Left = 360;
 $button.Top = 85;
 $button.Width = 100;
 $button.Text = “Continue”;

############# This is when you have to close the form after getting values
 $eventHandler = [System.EventHandler]{
 $textBox5.Text;
 $textBox6.Text;
 $form2.Close();};

$button.Add_Click($eventHandler) ;

#############Add controls to all the above objects defined
 $form2.Controls.Add($button);
 $form2.Controls.Add($textLabel5);
 $form2.Controls.Add($textLabel6);
 $form2.Controls.Add($textBox5);
 $form2.Controls.Add($textBox6);
 $ret = $form2.ShowDialog();
 
 
     Get-ChildItem $env:userprofile\AppData\Roaming\VanDyke\Config\Sessions -Recurse -Include *.ini |
    select -expand fullname |
        foreach {
            (Get-Content $_) -replace $textBox5.Text,$textBox6.Text |
                Set-Content $_
                    }
                    
                    $msgBoxInput0 = [System.Windows.MessageBox]::Show('Please re-verify your username information. Close both the file and the folder when finished.')
                    start $env:userprofile\AppData\Roaming\VanDyke\Config\Sessions
                    $msgBoxInput0 = [System.Windows.MessageBox]::Show('If you continue to experience issues, this script wont save you.')
                    