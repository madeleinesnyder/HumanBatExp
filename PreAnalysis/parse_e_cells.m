% parse event file
function [splitcell_line] = parse_e_cells(e_file_line)
    splitcell_line = regexp(e_file_line, '\s+', 'split');
end