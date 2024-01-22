function init(){
    var fileName = location.pathname.split("/").slice(-1)[0];
    console.log(fileName);

    if (fileName == 'index' || fileName == '') {
        alert("Hello!");

    } else if(fileName == 'senders') {
        function show() {
            fetch("/api", {
                method: "POST",
                body: JSON.stringify({
                    command: "getSenders"
                }),
                headers: {
                    "Content-type": "application/json; charset=UTF-8"
                }
            }).then((response) => response.json())
            .then((json) => {
                console.log(json);

                const myNode = document.getElementById("table");
                myNode.innerHTML = `<thead>
                <tr>
                <th scope="col">#</th>
                <th scope="col">Name</th>
                <th scope="col">Token</th>
                <th scope="col">Actions</th>
                </tr>
                </thead>`;

                myNode.innerHTML += `<tbody>`;

                for(sender of json) {
                    console.log(sender)
                    myNode.innerHTML += `<tr>
                    <th scope="row">${sender.id}</th>
                    <td>${sender.name}</td>
                    <td>${sender.token}</td>
                    <td>
                    <button type="button" class="btn btn-primary btn-change-name" id="c${sender.id}">Change name</button>
                    <button type="button" class="btn btn-warning btn-regenerate-token" id="r${sender.id}">Regenerate token</button>
                    <button type="button" class="btn btn-danger btn-delete-sender" id="d${sender.id}">Delete</button>
                    </td>
                    </tr>`;
                }
                

                myNode.innerHTML += `</tbody>`;

                const elements1 = document.querySelectorAll('.btn-change-name');
                elements1.forEach(function(element) {
                    element.addEventListener('click', c_event);
                });

                const elements2 = document.querySelectorAll('.btn-regenerate-token');
                elements2.forEach(function(element) {
                    element.addEventListener('click', r_event);
                });

                const elements3 = document.querySelectorAll('.btn-delete-sender');
                elements3.forEach(function(element) {
                    element.addEventListener('click', d_event);
                });

                const elements4 = document.querySelectorAll('.btn-add-sender');
                elements4.forEach(function(element) {
                    element.addEventListener('click', a_event);
                });

            });
        }

        var delayInMilliseconds = 4000; //1 second

        setTimeout(function() {
            //your code to be executed after 1 second
        }, delayInMilliseconds);

        show();

        function c_event(event) {
            const task_node = event.target;
            const taskID = task_node.id.substring(1);
            console.log(taskID);

            show();
        }

        function r_event(event) {
            const task_node = event.target;
            const taskID = task_node.id.substring(1);
            console.log(taskID);

            fetch("/api", {
                method: "POST",
                body: JSON.stringify({
                    command: "regenerateToken",
                    id: taskID
                }),
                headers: {
                    "Content-type": "application/json; charset=UTF-8"
                }
            }).then((response) => response.json())
            .then((json) => {
                console.log(json);
                if(json.message == 'OK')
                    show();
            });

            
        }

        function d_event(event) {
            const task_node = event.target;
            const taskID = task_node.id.substring(1);
            console.log(taskID);

            console.log(321321321);

            fetch("/api", {
                method: "POST",
                body: JSON.stringify({
                    command: "deleteSender",
                    id: taskID
                }),
                headers: {
                    "Content-type": "application/json; charset=UTF-8"
                }
            }).then((response) => response.json())
            .then((json) => {
                console.log(json);
                if(json.message == 'OK')
                    show();
            });
        }

        function a_event(event) {
            window.open("/add_sender","_self")
        }



        
    } else if(fileName == 'add_sender') {
        function a_event(argument) {
            const newInput = document.getElementById('inputName');
            console.log(newInput.value);

            fetch("/api", {
                method: "POST",
                body: JSON.stringify({
                    command: "createSender",
                    name: newInput.value
                }),
                headers: {
                    "Content-type": "application/json; charset=UTF-8"
                }
            }).then((response) => response.json())
            .then((json) => {
                console.log(json);
                if(json.message == 'OK')
                    window.open("/senders","_self")
            });

            

        }

        elements = document.querySelectorAll('.btn-add-sender');
        elements.forEach(function(element) {
            element.addEventListener('click', a_event);
        });
    }
};

document.addEventListener('DOMContentLoaded', init, false);


