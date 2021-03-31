<?php

session_start();

define('numFeatures',9); //number of features

$obtainedWeights=array(
array(-0.906180392594515,	0,	0,	0,	0,	-0.774705028543718,	-0.0682087240399700,	0,	-0.0588628418754542,	-0.930077066353323),
array(0,	-0.283210195802459,	0,	0,	0,	0.799066756862871,	-0.999547882908702,	-0.360908365496889,	0, 0),
array(-0.707298354012724,	0,	0,	-0.130052669705265,	-0.705951914904131,	0,	0,	-0.326769657240544,	-0.839642853236139,	-0.313521895368125),
array(0.137490329657491,	0,	0.869372826183251,	0.889446343491897,	-0.978308742437984,	-0.512149567758708,	-0.332062401141447,	0,	-0.614376791274674,	0),
array(0,	-0.738728225943353,	0,	0,	0.375258077179921,	0.953971845542826,	0,	0.748954920235117,	0,	0),
array(-0.292058770148240,	-0.824662770180369,	0.778818159542281,	0,	0,	0,	0,	0,	0.852481556124432,	0.647079564485482),
array(-0.612142393208256,	0.416559990667292,	0,	0,	0,	0,	0,	-0.215364388716813,	-0.275047949145174,	-0.616302996288101),
array(0.869948267977596,	-0.937447954665928,	0,	0,	-0.735564944735779,	0,	0,	-0.877131116778970,	0,	-0.999824892991357),
array(0,	0,	0,	0.945400753870771,	0.393145676104474,	0.444607307172364,	0,	-0.484836828968067,	0,	0.623420610337547),
array(1,	0,	0,	-0.403068517242143,	-0.787713246257627,	0,	0,	0,	0.447529838559745,	0)); //obtained from QFCM algorithm

$interSec = array(0, 0.075, 0.225, 0.4, 0.6, 0.85, 1); //intersections of fuzzy membership functions. They are decision boundries.
$classNames = array('Extremely Minor', 'Very Minor', 'Minor', 'Severe', 'Very Severe', 'Extremely Severe');  //name of the 6 classes

if (isset($_POST['uploadBtn'])) //is post method working properly?
{
	if (isset($_POST['termOfUse']) && $_POST['termOfUse'] == 'Yes')
	{
		if(isset(($_POST['Email'])))
		{
			if (isset($_FILES['uploadedFile']) && $_FILES['uploadedFile']['error'] === UPLOAD_ERR_OK) //was upload successful?
			{
				// get details of the uploaded file
				$fileTmpPath = $_FILES['uploadedFile']['tmp_name'];
				$fileName = $_FILES['uploadedFile']['name'];
				$fileSize = $_FILES['uploadedFile']['size'];
				$fileType = $_FILES['uploadedFile']['type'];
				$seperatedFileName = explode(".", $fileName);  //extract name and extension of the uploaded file in the seperatedFileName
				$fileExtension = strtolower(end($seperatedFileName)); //fileExtension includes the extension of the uploaded file
				$newFileName = md5(time() . $fileName) . '.' . $fileExtension; //making the name standard
			
				$ResponseFileName = explode(".", $newFileName);
				$ResponseFileName=$ResponseFileName[0];
			
				// check if file has one of the following extensions
				if ($fileExtension == 'txt')
				{
					$uploadFileDir = './uploaded_files/';
					$dest_path = $uploadFileDir . $newFileName;
					if(move_uploaded_file($fileTmpPath, $dest_path)) 
					{
						@ $fp = fopen($dest_path,'r');
						if (!$fp) //if the file can't be opened
						{
							echo '<p><strong> Sorry! Error in opening a file! please try again later. </strong></p>';
							exit;
						}
						$lineCounter=0;
						while (!feof($fp))
						{
							++$lineCounter;
							$temp = fgets($fp,999);
							$temp = array_map('floatval', explode(',', $temp));
					
					
							if (count($temp)!= numFeatures) //checking the number of features
							{
								echo '<p>Error in line </p>'.$lineCounter.'<p>each of rows is supposed to have 9 features. please refer to readme.txt the paper for more information</p>';
								exit;
							}
					
							$temp[] = 0.5; //pushing 0.5 to the end of the array as initial value of C10
					
							for($i=0;$i<numFeatures+1;++$i) //matrix multiplication for one iteration simulation
							{
								$add = 0.00;
								for($j=0;$j<numFeatures+1;++$j)
								{
									$add = $add + ($temp[$j] * $obtainedWeights[$j][$i]);
								}
								$oneIterSimulation[$i]=$add;
							}
					
							for($i=0;$i<numFeatures+1;++$i) //calculate the final one iteration simulation by using exp function, according to the FCM relatshonship
							{
								$oneIterSimulation[$i]= 1 / (1+exp(-5*$oneIterSimulation[$i]));
							}
					
					
							for($i=0;$i<numFeatures+1;++$i) //matrix multiplication for two iteration simulation
							{
								$add = 0.00;
								for($j=0;$j<numFeatures+1;++$j)
								{
									$add = $add + ($oneIterSimulation[$j] * $obtainedWeights[$j][$i]);
								}
								$twoIterSimulation[$i]=$add;
							}
					
							for($i=0;$i<numFeatures+1;++$i) //calculate the final two iteration simulation by using exp function, according to the FCM relatshonship
							{
								$twoIterSimulation[$i]= 1 / (1+exp(-5*$twoIterSimulation[$i]));
							}
					
							for($i=0;$i<count($interSec);$i++) //finding the index the class, to which the sample belongs. index of the class = i-1;
							{
								if ($interSec[$i]>$twoIterSimulation[numFeatures])
								{
									break;
								}
							}
							$class[$lineCounter-1]=$i-1; 
					
					
					
					
					
					
			
						}
						
						fclose($fp);
				
						//Generating Response file
						$dest_path_Response = $uploadFileDir . $ResponseFileName . '-Response' . '.' . 'txt';
						@ $fpResponse = fopen($dest_path_Response,'w');
						@ $fpReference = fopen($dest_path ,'r');
						if (!$fpResponse || !$fpReference) //if the file can't be opened
						{
							echo '<p><strong> Sorry! Error in opening a file! please try again later. </strong></p>';
							exit;
						}
						fwrite($fpResponse,"<b>". "Your results are as follow: ". "</b>". "\n");
						$lineCounter=0;
						while (!feof($fpReference))
						{
							$oneLine = fgets($fpReference,999);
							$tempString = "<p>" . rtrim($oneLine) . "\t\t\t" . "Diagnosed Severity: " . $classNames[$class[$lineCounter]]. "</p>" . "\n";
							fwrite($fpResponse, $tempString, strlen($tempString));
							++$lineCounter;
						}
						fclose($fpResponse);
						fclose($fpReference);
				
						readfile($dest_path_Response);
						
						@ $fp = fopen($dest_path ,'a+');
						if (!$fp) //if the file can't be opened
						{
							echo '<p><strong> Sorry! Error in opening a file! please try again later. </strong></p>';
							exit;
						}
						if(isset($_POST['realPatient'])) //check whether or not the user checked one of the radio buttons
						{
							if(strcasecmp($_POST['realPatient'], 'Yes') == 0)
							{
								fwrite($fp,"\n". "Real patient: ". "Yes". "\n");
							}
							elseif(strcasecmp($_POST['realPatient'], 'No') == 0)
							{
								fwrite($fp,"\n". "Real patient: ". "No". "\n");
							}
						}
						else
						{
							fwrite($fp,"\n". "Real patient: ". "not answered by the user". "\n");
						}
						
						fwrite($fp,"Email address: ". $_POST['Email']. "\n");  //writing email address
						fclose($fp);
				
					}
					else 
					{
						echo '<p>Error in moving the file to the directory. please try again later. if the error persistsو please contact to mojtaba.kolahdoozi@gmail.com</p>';
					}
			  
				}
				else
				{
					echo '<p>Sorry! The only allowed file type is .txt</p>';
					exit;
				}
			}
			else
			{
				echo '<p>Sorry! An error occured in the process of uploading... please try again later. If the error persists please contact to mojtaba.kolahdoozi@gmail.com </p>';
				exit;
			}
		}
		else
		{
			echo '<p>Sorry! For accessing the results you must enter your Email address </p>';
			exit;
		}
	}
	else
	{
		echo '<p> Sorry! for accessing the results you must agree with terms of use! </p>';
		exit;
	}
}
else
{
	echo '<p>An error occured in the post method. please try again later</p>';
	exit;
}

?>
