%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%JAI CHUNG PP2 COMP135%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Please run on MATLAB 2016 or higher
% Please cd to a directory that contains the folder 'sentiment labelled
% sentences', which contains the text files. Also have maxdim.m and 
% first.m files on the same directory.
% If 'dir' is runned, the following must be returned in order to run:
% hwk2.m
% first.m
% maxdim.m
% senteiment labelled sentences



if ismac == 1
    folder = 'sentiment labelled sentences/';
    tdir = strcat(folder,'*labelled*.txt');
elseif ispc == 1
    folder = 'sentiment labelled sentences\';
    tdir = strcat(folder,'*labelled*.txt');
end
colors = [{double([228 26 28])} double([55 126 184]) double([77 175 74])];
ranges = [{0.9:9.9} {1:10} {1.1:10.1}];
for iii = 1:3
    for m = 0:1
        if m == 0
            t_dir = dir(tdir);
            data = fopen(strcat(folder,t_dir(iii).name));             
            data_t = textscan(data,'%s','delimiter','\n');
            fclose(data);

            max_word = maxdim(data_t{1});

            words = strings(1000,max_word);
            words_n = strings(1000,max_word);
            words_p = strings(1000,max_word);
            word_n = zeros(1000,1);

            for ii = 1:1000
                word_s = textscan(data_t{1}{ii},'%s');
                word_n(ii) = str2num(cell2mat(word_s{1}(end)));
                word_s = word_s{1}(1:end-1);

                if word_n(ii) == 0
                    for i = 1:size(word_s,1)
                        wo_temp = word_s{i};
                        words_n(ii,i) = lower(wo_temp(isstrprop(wo_temp,...
                            'alpha')));
                        words(ii,i) = lower(wo_temp(isstrprop(wo_temp,...
                            'alpha')));
                    end
                else
                    for i = 1:size(word_s,1)
                        wo_temp = word_s{i};
                        words_p(ii,i) = lower(wo_temp(isstrprop(wo_temp,...
                            'alpha')));
                        words(ii,i) = lower(wo_temp(isstrprop(wo_temp,...
                            'alpha')));
                    end
                end        
            end  

            vocab_n = length(unique(words))-1;
        end

        accu = zeros(10);
        
        for ni = 1:10
            rn = randperm(1000,100*ni);
            rn_p = rn(find(word_n(rn)==1));
            rn_n = rn(find(word_n(rn)==0));
            p = length(find(word_n(rn)==1));
            n = length(find(word_n(rn)==0));
            words_p = strings(1000,max_word);
            words_n = strings(1000,max_word);
            [p, n] = first(p,n);
            for pn = 1:10
                pn_i = [rn_p(1+(p*(pn-1)):p*pn) rn_n(1+...
                    (n*(pn-1)):n*pn)];
                pn_i_d = [setdiff(rn_p, pn_i) setdiff(rn_n, pn_i)];
                for iid = 1:length(pn_i_d)
                    word_s = textscan(data_t{1}{pn_i_d(iid)},'%s');
                    word_s = word_s{1}(1:end-1);
                    if word_n(pn_i_d(iid)) == 0
                        for i = 1:size(word_s,1)
                            wo_temp = word_s{i};
                            words_n(ii,i) = lower(wo_temp(...
                                isstrprop(wo_temp,'alpha')));
                        end
                    elseif word_n(pn_i_d(iid)) == 1
                        for i = 1:size(word_s,1)
                            wo_temp = word_s{i};
                            words_p(ii,i) = lower(wo_temp(...
                                isstrprop(wo_temp,'alpha')));
                        end
                    end
                end

                word_loc_p = length(words_p(~cellfun('isempty',...
                    cellstr(rmmissing(words_p)))));
                word_loc_n = length(words_n(~cellfun('isempty',...
                    cellstr(rmmissing(words_n)))));
                words_pp = rmmissing(unique(words_p));
                words_pp = words_pp(2:end);
                words_nn = rmmissing(unique(words_n));
                words_nn = words_nn(2:end);

                prob_p = cell(length(words_pp),2);
                prob_n = cell(length(words_nn),2);
                prob = cell(length(pn_i),3);

% % % % % % % % % % Compute Probability of 0 and 1 features
                for ppn = 1:2
                    if ppn == 1
                        for ip = 1:length(words_pp)
                            prob_p(ip,1) = cellstr(words_pp(ip));
                            prob_p(ip,2) = num2cell((length(...
                                find(words_pp(ip) == words_p))+m)/...
                                (word_loc_p+m*vocab_n));
                        end
                    else
                        for ip = 1:length(words_nn)
                            prob_n(ip,1) = cellstr(words_nn(ip));
                            prob_n(ip,2) = num2cell((length(...
                                find(words_nn(ip) ==words_n))+m)/...
                                (word_loc_n+m*vocab_n));
                        end
                    end
                end

                acc = 0;
                for pn_ii = 1:length(pn_i)
                    prob(pn_ii) = cellstr(data_t{1}{pn_i(pn_ii)});
                    sent = textscan(char(prob(pn_ii)),'%s');
                    feat = str2double(sent{1}(end));
                    if feat == 1
                        for i = 1:size(sent,1)
                            wo_temp = sent{1}{i};
                            word = lower(wo_temp(...
                                isstrprop(wo_temp,'alpha')));
                            if isempty(find(strcmp(prob_n, word),...
                                    1)) == 1
                                prob_pp = 1;
                                prob_nn = 0;
                                i = size(sent,1);
                            else
                                p_i = find(strcmp(prob_p, word),1);
                                n_i = find(strcmp(prob_n, word),1);
                                if isempty(p_i) ==  1
                                    prob_pp = 0;
                                    prob_nn = 1;
                                    i = size(sent,1);
                                else
                                    if i == 1
                                        prob_pp = 0.5*prob_p{...
                                            p_i,2};
                                        prob_nn = 0.5*prob_n{...
                                            n_i,2};
                                    else
                                        prob_pp = prob_pp*...
                                            prob_p{p_i,2};
                                        prob_nn = prob_nn*...
                                            prob_n{n_i,2};
                                    end
                                end


                            end
                        end
                        if prob_pp > prob_nn
                            acc = acc + 1;
                        else
                            acc = acc;
                        end
                    else
                        for i = 1:size(sent,1)
                            wo_temp = sent{1}{i};
                            word = lower(wo_temp(...
                                isstrprop(wo_temp,'alpha')));
                            if isempty(find(strcmp(prob_p, word),...
                                    1)) == 1
                                prob_pp = 0;
                                prob_nn = 1;
                                i = size(sent,1);
                            else
                                p_i = find(strcmp(prob_p, word),1);
                                n_i = find(strcmp(prob_n, word),1);
                                if isempty(n_i) ==  1
                                    prob_pp = 1;
                                    prob_nn = 0;
                                    i = size(sent,1);
                                else
                                    if i == 1
                                        prob_pp = 0.5*prob_p{p_i,2};
                                        prob_nn = 0.5*prob_n{n_i,2};
                                    else
                                        prob_pp = prob_pp*prob_p{p_i,2};
                                        prob_nn = prob_nn*prob_n{n_i,2};
                                    end
                                end
                            end
                        end
                        if prob_nn > prob_pp
                            acc = acc + 1;
                        else
                            acc = acc;
                        end
                    end
                end
                accu(pn,ni) = acc/(ni*10);
            end
        end
        
        me_accu = 100*mean(accu);
        st_accu = 100*std(accu);
        
        if m == 0
            f = errorbar(ranges{iii},me_accu, st_accu,...
                'Marker','x','MarkerSize',10,'LineWidth', 2);
            f.Color = colors{iii}/255;
            if iii == 1
                axis([0.5 10.5 35 105])
                title('NB Algorithm Accuracy (w/wo Laplace Smoothing)')
                set(gca,'fontsize',12)
                xlabel('$$n$$, for $$N = 100*n$$','Interpreter', ...
                    'Latex','FontSize',16)
                ylabel('Accuracy (%)','FontSize',16)
                grid on
                text(1,40,'Jai Chung, PP2 Fall ''17', 'FontSize', 16)
                hold on
            end
            
        else
            g = errorbar(ranges{iii},me_accu, st_accu,...
                'Marker','o','MarkerSize',10,'LineWidth', 1);
            g.Color = colors{iii}/255;
        end
    end
end
[l, hobj, hout, mout] = legend('Amazon, m = 0','Amazon, m = 1',...
    'IMDB, m = 0','IMDB, m = 1',...
    'Yelp, m = 0','Yelp, m = 1');
M = findobj(hobj,'type','patch');
set(M,'MarkerSize', 10, 'MarkerWidth', 2)
legend('Location','southeast')
hold off

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

m = [linspace(0,1,11) linspace(2,10,9)];
ms = [0.08 linspace(0.1,1,10) linspace(2,10,9)];
files = [{' (Amazon)'} {' (IMDB)'} {' (Yelp)'}];
figure
for iii = 1:3
    accu = zeros(10,20);

    for mmm = 1:20
        if m(mmm) == 0
            t_dir = dir(tdir);
            data = fopen(strcat(folder,t_dir(iii).name));             
            data_t = textscan(data,'%s','delimiter','\n');
            fclose(data);

            max_word = maxdim(data_t{1});

            words = strings(1000,max_word);
            words_n = strings(1000,max_word);
            words_p = strings(1000,max_word);
            word_n = zeros(1000,1);

            for ii = 1:1000
                word_s = textscan(data_t{1}{ii},'%s');
                word_n(ii) = str2num(cell2mat(word_s{1}(end)));
                word_s = word_s{1}(1:end-1);

                if word_n(ii) == 0
                    for i = 1:size(word_s,1)
                        wo_temp = word_s{i};
                        words_n(ii,i) = lower(wo_temp(isstrprop(wo_temp,...
                            'alpha')));
                        words(ii,i) = lower(wo_temp(isstrprop(wo_temp,...
                            'alpha')));
                    end
                else
                    for i = 1:size(word_s,1)
                        wo_temp = word_s{i};
                        words_p(ii,i) = lower(wo_temp(isstrprop(wo_temp,...
                            'alpha')));
                        words(ii,i) = lower(wo_temp(isstrprop(wo_temp,...
                            'alpha')));
                    end
                end        
            end  

            vocab_n = length(unique(words))-1;
        end
        rn = randperm(1000);
        rn_p = rn(find(word_n(rn)==1));
        rn_n = rn(find(word_n(rn)==0));
        p = length(find(word_n(rn)==1));
        n = length(find(word_n(rn)==0));
        words_p = strings(1000,max_word);
        words_n = strings(1000,max_word);
        [p, n] = first(p,n);
        for pn = 1:10
            pn_i = [rn_p(1+(p*(pn-1)):p*pn) rn_n(1+...
                (n*(pn-1)):n*pn)];
            pn_i_d = [setdiff(rn_p, pn_i) setdiff(rn_n, pn_i)];
            for iid = 1:length(pn_i_d)
                word_s = textscan(data_t{1}{pn_i_d(iid)},'%s');
                word_s = word_s{1}(1:end-1);
                if word_n(pn_i_d(iid)) == 0
                    for i = 1:size(word_s,1)
                        wo_temp = word_s{i};
                        words_n(ii,i) = lower(wo_temp(...
                            isstrprop(wo_temp,'alpha')));
                    end
                elseif word_n(pn_i_d(iid)) == 1
                    for i = 1:size(word_s,1)
                        wo_temp = word_s{i};
                        words_p(ii,i) = lower(wo_temp(...
                            isstrprop(wo_temp,'alpha')));
                    end
                end
            end

            word_loc_p = length(words_p(~cellfun('isempty',...
                cellstr(rmmissing(words_p)))));
            word_loc_n = length(words_n(~cellfun('isempty',...
                cellstr(rmmissing(words_n)))));
            words_pp = rmmissing(unique(words_p));
            words_pp = words_pp(2:end);
            words_nn = rmmissing(unique(words_n));
            words_nn = words_nn(2:end);

            prob_p = cell(length(words_pp),2);
            prob_n = cell(length(words_nn),2);
            prob = cell(length(pn_i),3);

% % % % % % % % % % Compute Probability of 0 and 1 features
            for ppn = 1:2
                if ppn == 1
                    for ip = 1:length(words_pp)
                        prob_p(ip,1) = cellstr(words_pp(ip));
                        prob_p(ip,2) = num2cell((length(...
                            find(words_pp(ip) == words_p))+m(mmm))/...
                            (word_loc_p+m(mmm)*vocab_n));
                    end
                else
                    for ip = 1:length(words_nn)
                        prob_n(ip,1) = cellstr(words_nn(ip));
                        prob_n(ip,2) = num2cell((length(...
                            find(words_nn(ip) ==words_n))+m(mmm))/...
                            (word_loc_n+m(mmm)*vocab_n));
                    end
                end
            end

            acc = 0;
            
            for pn_ii = 1:length(pn_i)
                prob(pn_ii) = cellstr(data_t{1}{pn_i(pn_ii)});
                sent = textscan(char(prob(pn_ii)),'%s');
                feat = str2double(sent{1}(end));
                if feat == 1
                    for i = 1:size(sent,1)
                        wo_temp = sent{1}{i};
                        word = lower(wo_temp(...
                            isstrprop(wo_temp,'alpha')));
                        if isempty(find(strcmp(prob_n, word),...
                                1)) == 1
                            prob_pp = 1;
                            prob_nn = 0;
                            i = size(sent,1);
                        else
                            p_i = find(strcmp(prob_p, word),1);
                            n_i = find(strcmp(prob_n, word),1);
                            if isempty(p_i) ==  1
                                prob_pp = 0;
                                prob_nn = 1;
                                i = size(sent,1);
                            else
                                if i == 1
                                    prob_pp = 0.5*prob_p{...
                                        p_i,2};
                                    prob_nn = 0.5*prob_n{...
                                        n_i,2};
                                else
                                    prob_pp = prob_pp*...
                                        prob_p{p_i,2};
                                    prob_nn = prob_nn*...
                                        prob_n{n_i,2};
                                end
                            end


                        end
                    end
                    if prob_pp > prob_nn
                        acc = acc + 1;
                    else
                        acc = acc;
                    end
                else
                    for i = 1:size(sent,1)
                        wo_temp = sent{1}{i};
                        word = lower(wo_temp(...
                            isstrprop(wo_temp,'alpha')));
                        if isempty(find(strcmp(prob_p, word),...
                                1)) == 1
                            prob_pp = 0;
                            prob_nn = 1;
                            i = size(sent,1);
                        else
                            p_i = find(strcmp(prob_p, word),1);
                            n_i = find(strcmp(prob_n, word),1);
                            if isempty(n_i) ==  1
                                prob_pp = 1;
                                prob_nn = 0;
                                i = size(sent,1);
                            else
                                if i == 1
                                    prob_pp = 0.5*prob_p{p_i,2};
                                    prob_nn = 0.5*prob_n{n_i,2};
                                else
                                    prob_pp = prob_pp*prob_p{p_i,2};
                                    prob_nn = prob_nn*prob_n{n_i,2};
                                end
                            end
                        end
                    end
                    if prob_nn > prob_pp
                        acc = acc + 1;
                    else
                        acc = acc;
                    end
                end
            end
            
            accu(pn,mmm) = acc/(ni*10);
        end
        
        if m(mmm) == 10
            subplot(3,1,iii)
            me_accu = 100*mean(accu);
            st_accu = 100*std(accu);
            f = errorbar(ms,me_accu, st_accu,...
                'Marker','*','MarkerSize',10,'LineWidth', 1);
            f.Color = colors{iii}/255;
            axis([-.5 10.5 60 90])
            ti = strcat('NB Algorithm Accuracy, by smoothing parameter'...
                , files(iii));
            title(ti)
            set(gca,'fontsize',10)
            set(gca,'Xscale','log')
            set(gca,'xtick',m)
            xlabel('$$m$$, (log scaled)','Interpreter', 'Latex',...
                'FontSize',12)
            ylabel('Accuracy (%)','FontSize',12)
            grid on
            text(0.1,65,'Jai Chung, PP2 Fall ''17', 'FontSize', 12)
            hold on
        end
    end
end