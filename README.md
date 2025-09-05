# arabidopsis_med8_chip_hub
This repository is about creating a public ```Track Hub``` for our Mediator ChIP-seq (ChIPed with Med8) on Col-0 (wild-type ) and med18 mutants under control condition. 
Since, we used custom genome having chromosome names "Chr" which are not compatible with ```UCSC``` genome browser, we had to make our own ```Track Hub``` to visualize 
our data. The detail procedure is given on the ```UCSC``` website and can be found here (setting up your own tracks)[https://genome-euro.ucsc.edu/goldenPath/help/hgTrackHubHelp.html#Setup].
The first step include formating the data in a way that can be supported on ```UCSC browser```, In our case we have ```bigwig files``` that are compatible with the ```UCSC browser```. 
Next, we need to host our data to an internet-accessible location or ftp server. We have used ```figshare``` to store our ```bigwig files``` because of the size and limit constraints on ```GitHub```. We would need a downloadble link for those files stored on ```figshare``` that can be obtained by going to your folder on ```figshare``` click on ```Manage files``` then click on the ```...``` icon in the ```Action``` column. 
Next, we need to create a ```GitHub``` repository with the following structure 
## Directory Structure

```plaintext
                        
 hubDirecotry/               
    ├── hub.txt         
    ├── genomes.txt
    └── TAIR10/           
        ├── trackDb.txt   
