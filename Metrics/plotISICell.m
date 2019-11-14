function plotISICell(cell_id)

load(getDatasetMat(), 'spikes', 'params');

ISI = diff(spikes{cell_id} / params.meaRate) * 1000;  % Convert to ms
ISI = ISI(ISI<=25);
histogram(ISI, 100);


