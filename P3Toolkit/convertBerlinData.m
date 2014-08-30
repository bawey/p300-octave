%This method loads the BERLIN BCI COMPETITION DATA from the original files provided by competition holders, converts them to P3Session objects and saves as such
%Depending on the contents of the folder, either the BCI competition 2 or BCI compettion 3 data will be loaded automatically.
%First argument denotes the output directory, whatever comes next is considered to be an input dir hosting the Berlin data from either competition

%sample invocation: convertBerlinData('~/Copy/eeg/p3berlin','~/Copy/eeg/berlin.bci.iii','~/Copy/eeg/berlin.bci.ii');

function convertBerlinData(outdir, varargin)
    assert(exist(outdir, 'dir')==7, 'Output directory does not exist');
    for(dir = varargin)
        fprintf('Scanning the directory %s...\n', dir{:});
        assert(exist(dir{:}, 'dir')==7,sprintf('Intput directory %s does not exist', dir{:}));
        %BERLIN II DATASET
        if(exist(sprintf('%s/AAS012R06.mat',dir{:}))==2)
            printf('%s is a Berlin II data directory!\n', dir{:});
            
            savepath=sprintf('%s/%s', outdir, 'p3tt-berlin2.oct');
            
            if(exist(savepath)~=2)
                train_files={};
                test_files={};
                for(i=1:8)
                    test_files{end+1}=sprintf('%s/AAS012R%02d.mat', dir{:}, i);
                endfor;
                
                for(i=1:5)
                    train_files{end+1}=sprintf('%s/AAS010R%02d.mat', dir{:}, i);
                endfor;
                
                %here shour be 6, but AAS001R1106.mat contains some oddities. we'll train on less samples then(for now at least)
                for(i=1:6)
                    train_files{end+1}=sprintf('%s/AAS011R%02d.mat', dir{:}, i);
                endfor;

                %load the test data and training data
                p3test=P3SessionBerlin(test_files{:});
                p3train=P3SessionBerlin(train_files{:});
                teststring=strcat('FOOD','MOOT','HAM','PIE','CAKE','TUNA','ZYGOT','4567');
                
                save('-binary',savepath, 'p3train', 'p3test', 'teststring');
            else
                fprintf('file %s already exists, skipping...\n', savepath);
            endif;

        %BERLIN III DATASET
        elseif(exist(sprintf('%s/Subject_A_Train.mat',dir{:})))
            printf('%s is a Berlin III data directory!\n', dir{:});
            
            files={'Subject_A_Train.mat', 'Subject_A_Test.mat', 'Subject_B_Train.mat', 'Subject_B_Test.mat'};

            %try loading
            savepath=sprintf('%s/%s', outdir, 'p3tt-berlin3a.oct');
            if(exist(savepath)~=2)
                p3train=P3SessionBerlin3(sprintf('%s/%s', dir{:}, files{1}));
                p3test=P3SessionBerlin3(sprintf('%s/%s', dir{:}, files{2}));
                teststring='WQXPLZCOMRKO97YFZDEZ1DPI9NNVGRQDJCUVRMEUOOOJD2UFYPOO6J7LDGYEGOA5VHNEHBTXOO1TDOILUEE5BFAEEXAW_K4R3MRU';
                
                save('-binary', savepath, 'p3train', 'p3test', 'teststring');
            else
                fprintf('file %s already exists, skipping...\n', savepath);
            endif;
            
            
            savepath=sprintf('%s/%s', outdir, 'p3tt-berlin3b.oct');
            if(exist(savepath)~=2)
                p3train=P3SessionBerlin3(sprintf('%s/%s', dir{:}, files{3}));
                p3test=P3SessionBerlin3(sprintf('%s/%s', dir{:}, files{4}));
                teststring='MERMIROOMUHJPXJOHUVLEORZP3GLOO7AUFDKEFTWEOOALZOP9ROCGZET1Y19EWX65QUYU7NAK_4YCJDVDNGQXODBEV2B5EFDIDNR';

                save('-binary', savepath, 'p3train', 'p3test', 'teststring');
            else
                fprintf('file %s already exists, skipping...\n', savepath);
            endif;
        endif;
    endfor;
endfunction;