let checkTime = null;
var fs = require("fs");
axios.get("main.db", { responseType: 'arraybuffer' })
    .then(function (response) {
        let db = new window.SQL.Database(new Uint8Array(response.data));
        // 执行查询
        let s = new Date().getTime();
        let r = db.exec("SELECT * FROM time_schedule;");
        let e = new Date().getTime();
        console.info("查询数据耗时：" + (e - s) + "ms");
        // 解析数据
        checkTime = dbToObj(r);

        console.info(checkTime);
        var timer = setInterval(function () {
            var nowDate = new Date();
            var nowHour = parseInt(nowDate.getHours());
            var nowMinute = parseInt(nowDate.getMinutes());
            var res = 0;
            for (var i = 0; i <= 24; i++) {
                checkHour = parseInt(checkTime[i].hour);
                checkMinute = parseInt(checkTime[i].minute);
                if (parseInt(nowHour) == checkHour && parseInt(nowMinute) == checkMinute) res += 1;
            }
            if (res != 0 && nowDate.getSeconds() == 1) {
                playAudio()
            }
        }, 1000);
        var selector = document.getElementById("change-time");
        for (var i = 0; i < checkTime.length; i++) {
            var option = document.createElement("option");
            console.info(checkTime[i].hour);
            option.value = checkTime[i].id;
            //获取checkTime[i].id对应的时间点hour和minute，小于10的在前面均要补0，如：09:30
            option.text = checkTime[i].hour < 10 ? "0" + checkTime[i].hour : checkTime[i].hour;
            option.text += ":";
            option.text += checkTime[i].minute < 10 ? "0" + checkTime[i].minute : checkTime[i].minute;
            selector.appendChild(option);
        }
        layui.use('form', function () {
            var form = layui.form;
            form.on('submit(formDemo)', function (data) {
                var formResult = JSON.stringify(data.field);
                formResult = eval('(' + formResult + ')');
                //main.db中替换原先id中的数据，hour代表小时，minute代表分钟，change-time代表id
                db.run("UPDATE time_schedule SET hour=" + formResult.hour + ",minute=" + formResult.minute + " WHERE id=" + formResult['change-time'] + ";");
                //UPDATE time_schedule SET hour=7,minute=0 WHERE id=2;
                //将修改后的数据重新导出到main.db中
                var data = db.export();
                var buffer = new Buffer(data);
                fs.writeFileSync("resources/app/main.db", buffer);
                fs.writeFileSync("main.db", buffer);
                db.close();
                swal("成功", "时间已更改！将在一秒后刷新。", "success");
                setTimeout(function () {
                    window.location.reload();
                }, 1000);
                console.log("UPDATE time_schedule SET hour=" + formResult.hour + ",minute=" + formResult.minute + " WHERE id=" + formResult['change-time'] + ";");
                return false;
            });
        });
    })
    .catch(function (error) {
        console.info(error);
    });

const ArraytoObj = (keys = [], values = []) => {
    if (keys.length === 0 || values.length === 0) return {};
    const len = keys.length > values.length ? values.length : keys.length;
    const obj = {};
    for (let i = 0; i < len; ++i) {
        obj[keys[i]] = values[i]
    }
    return obj;
};
// 转驼峰表示：func.camel('USER_ROLE',true) => UserRole
// 转驼峰表示：func.camel('USER_ROLE',false) => userRole
const camel = (str, firstUpper = false) => {
    let ret = str.toLowerCase();
    ret = ret.replace(/_([\w+])/g, function (all, letter) {
        return letter.toUpperCase();
    });
    if (firstUpper) {
        ret = ret.replace(/\b(\w)(\w*)/g, function ($0, $1, $2) {
            return $1.toUpperCase() + $2;
        });
    }
    return ret;
};
// 把数组里面的所有转化为驼峰命名
const camelArr = (arrs = []) => {
    let _arrs = [];
    arrs.map(function (item) {
        _arrs.push(camel(item));
    });
    return _arrs;
};
// 读取数据库
// 1.把columns转化为驼峰；
// 2.把columns和values进行组合；
const dbToObj = (_data = {}) => {
    let _res = [];
    _data.map(function (item) {
        let _columns = camelArr(item.columns);
        item.values.map(function (values) {
            _res.push(ArraytoObj(_columns, values));
        });
    });
    return _res;
};

var audio = document.getElementById('musicPlay');

function playAudio() {
    audio.currentTime = 0;
    audio.play();
}

function swalring() {
    swal("成功", "手动打铃成功！", "success");
}