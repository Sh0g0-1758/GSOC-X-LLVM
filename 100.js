function populateTable(filenames) {
    const tableBody = document.getElementById('jsonTable').getElementsByTagName('tbody')[0];
    filenames.forEach(filename => {
        const row = document.createElement('tr');
        const cell = document.createElement('td');
        const link = document.createElement('a');
        link.href = `graph100.html?file=${filename}`;
        link.textContent = filename.replace('.json', '');
        cell.appendChild(link);
        row.appendChild(cell);
        tableBody.appendChild(row);
    });
}

document.addEventListener("DOMContentLoaded", function () {
    fetch('content/filelist.json')
        .then(response => response.json())
        .then(data => {
            populateTable(data);
        })
    }
);
