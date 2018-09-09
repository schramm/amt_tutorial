
function [nnmf_templates, nnmf_activations] = extractKtemplatesPerNote(notes, K)

nnmf_templates = [];
nnmf_activations = [];
%k templates for note
for i=1:size(notes,3)
     
    [w,h] = nnmf(notes(:,:,i), K);    
    
    nnmf_templates(:,i,:) = w;
    nnmf_activations(:,i,:) = h;
    
%     subplot(1,2,1); imagesc(w);
%     subplot(1,2,2); imagesc(h);
%     shg;
%     pause(.05);
   
end