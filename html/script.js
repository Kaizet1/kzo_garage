
$(document).ready(function() {
  function capitalizeFirstLetter(str) {
    return str.charAt(0).toUpperCase() + str.slice(1);
  }
  window.addEventListener('message', function(event) {
    if (event.data.type == 'garage') {
        $('#box').empty();
        $('#footer').empty();
        $('#footer').off('click');
        $('.item').off('click');
        $('.main').fadeIn();
        let evn = event.data.result;
        if (evn.length <= 4){
          $("#box").css("height", "50vh");
          $(".footer").css("margin-top", "30vh");
        }else{
          $("#box").css("height", "80vh");
          $(".footer").css("margin-top", "2vh");
        }
        for (let i = 0; i < evn.length; i++) {
            let dongco = Math.floor(evn[i].vehicle.bodyHealth / 1000 * 100)
            let thanxe = Math.floor(evn[i].vehicle.engineHealth / 1000 * 100)
            if (evn[i].data.stored == 1){
            $('#box').append(`
             <div class="item" id="${i}">
                    <div class="content">
                        <div class="vehname">${capitalizeFirstLetter(evn[i].data.name)}</div>
                        <div class="enginehealth"><img src="imgs/engine.png" ><span>${dongco}%</span></div>
                        <div class="vehplate">${evn[i].data.plate}</div>
                        <div class="bodyhealth"><img src="imgs/body.png" ><span>${thanxe}%</span></div>
                    </div>
                    <div class="image">
                      <img src="imgs/oto.png">
                    </div>
                </div>
            `);
        }else{
          $('#box').append(`
          <div class="item" id="${i}">
                 <div class="content">
                     <div class="vehname">${capitalizeFirstLetter(evn[i].data.name)}</div>
                     <div class="enginehealth"><img src="imgs/engine.png" ><span>${dongco}%</span></div>
                     <div class="vehplate" style="color: #e9ed1e;">${evn[i].data.plate}</div>
                     <div class="bodyhealth"><img src="imgs/body.png" ><span>${thanxe}%</span></div>
                 </div>
                 <div class="image">
                   <img src="imgs/oto.png">
                 </div>
             </div>
         `);
        }
                          
        }

$('.item').on('click', function() {
  var footer = $('#footer');
  var index = $('.item').index(this);
  footer.empty();
  if (evn[index].data.stored == 0) {
    footer.append(`
      <div class="layxe">Reclaim Vehicle</div>
      <div class="doiten">Change vehicle name</div>
      <div class="xoaxe">Delete vehicle</div>
    `);
  } else {
    footer.append(`
      <div class="layxe">Retrieve vehicle</div>
      <div class="doiten">Change vehicle name</div>
      <div class="xoaxe">Delete vehicle</div>
    `);
  }
  
  footer.addClass('show-footer');
});
var items = document.getElementsByClassName("item");
var selected;
for (var i = 0; i < items.length; i++) {
  items[i].addEventListener("click", function() {
    for (var j = 0; j < items.length; j++) {
      items[j].classList.remove("selected-item");
    }
    this.classList.add("selected-item");
    selected = this;
  });
}

$('#footer').on('click', '.layxe', function() {       
 let number = $(selected).attr('id');
  let data = evn[number];
                $.post('http://kzo_garage/Getcar', JSON.stringify({
                    data: data
                }));
                $('.main').fadeOut();
                $.post('http://kzo_garage/hide', JSON.stringify({}));
})
$('#footer').on('click', '.doiten', async function() {  
  let number = $(selected).attr('id');
  const result = await Swal.fire({
      title: 'Change vehicle name',
      input: 'text',
      inputLabel: 'Enter name...',
      inputValue: "",
      showCancelButton: true,
      cancelButtonText: 'Cancel',
      inputValidator: (value) => {
          if (!value) {
              return 'You need to enter a name'
          }
      }
  });
  let value = result.value;
  if (result.isConfirmed) {
      var plate = evn[number].data.plate;
      await $.post('http://kzo_garage/Changename', JSON.stringify({
          plate: plate,
          value: value
      }));
  }
});

$('#footer').on('click', '.xoaxe', function() {   
  let number = $(selected).attr('id');
  let plate = evn[number].data.plate;
  Swal.fire({
      title: 'Delete vehicle',
      text: `Are you sure?`,
      icon: 'question',
      showCancelButton: true,
      confirmButtonColor: '#d33',
      cancelButtonColor: '#3085d6',
      confirmButtonText: 'Yes',
      cancelButtonText: 'No'
  }).then((result) => {
      if (result.isConfirmed) {
          $.post('http://kzo_garage/DeleteVehicle', JSON.stringify({
              plate: plate
          }));
      }
  })
}) 

}
});
$(".exit").click(function(){
  $('.main').fadeOut();
  $.post('http://kzo_garage/hide', JSON.stringify({}));
}) 
$(document).ready(function() {
  document.onkeyup = function(data) {
      if (data.which == 27) {
        $('.main').fadeOut();
        $.post('http://kzo_garage/hide', JSON.stringify({}));
      }
  };
});
});