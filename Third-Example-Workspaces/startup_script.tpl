#! /bin/bash
sudo amazon-linux-extras install -y nginx1
sudo service nginx start
sudo mkdir website
aws s3 sync s3://${s3_bucket_name} /home/ec2-user/website/
#aws s3 cp s3://${s3_bucket_name}/website/Globo_logo_Vert.png /home/ec2-user/Globo_logo_Vert.png
sudo rm /usr/share/nginx/html/index.html
sudo cp -avr /home/ec2-user/website/* /usr/share/nginx/html/
#sudo cp /home/ec2-user/Globo_logo_Vert.png /usr/share/nginx/html/Globo_logo_Vert.png