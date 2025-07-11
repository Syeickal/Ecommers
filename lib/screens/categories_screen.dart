import 'package:ecommerce_app/screens/category_products_screen.dart';
import 'package:flutter/material.dart';

// Model untuk Kategori
class Category {
  final String name;
  final String imageUrl;

  Category({required this.name, required this.imageUrl});
}

class CategoriesScreen extends StatelessWidget {
  CategoriesScreen({super.key});

  // Ganti daftar kategori menjadi berbagai jenis sepatu
  final List<Category> categories = [
    Category(name: 'Running', imageUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=500'),
    Category(name: 'Sneakers', imageUrl: 'https://images.unsplash.com/photo-1600185365926-3a2ce3cdb9eb?w=500'),
    Category(name: 'Formal', imageUrl: 'https://images.unsplash.com/photo-1549298916-b41d501d3772?w=500'),
    Category(name: 'Boots', imageUrl: 'data:image/jpeg;base64,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'),
    Category(name: 'Heels', imageUrl: 'data:image/jpeg;base64,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'),
    Category(name: 'Sandals', imageUrl: 'data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wCEAAkGBw0HERAPEA8QEA4SCwoNEAoYCw8PFQ0KIBEXIiAdHx8kKCksJCYlJx8fLTEtMSstLi43Ix8zOjcsNygtLisBCgoKBgwGDg8PDisZExkrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrK//AABEIAMgAyAMBIgACEQEDEQH/xAAcAAEAAQUBAQAAAAAAAAAAAAAABAMFBgcIAgH/xAA5EAACAQIDBQYDBgUFAAAAAAAAAQIDEQQhMQUGEkFREyJhcYGRBzLBFEJSobHwIzNi0fFygpKT4f/EABUBAQEAAAAAAAAAAAAAAAAAAAAB/8QAFBEBAAAAAAAAAAAAAAAAAAAAAP/aAAwDAQACEQMRAD8A3iAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA88S6+lz0AAAAAAAAAAAAAAAAAAAAAAAAABAxu18Js/8AnYijSf4ZV4Qfs2Wx77bITt9to30+Z297WAyIpVq0KEXOcoxhFXlNyUVFeLehjW3d+tm7JoSrxr0q8rqMKFOrGUp1XonbRdW//DTm8O+ON3nv2s1Ck1xU8LGXDBQ62fzPJ3b9LLIDZW1fi5srA1OzgqteKck60IJR4l0u1fPn65mJbf8AifjdoXVBLDUcndO9ScE7Pvcs7JWS55ms8ZFVLSd+HW/Da0le6SzX75EjA4mE6ceHj7aMpXyTXDqrc8rNvyQF3jtCup9t2s3Ui+0VZzm25J55+dl+7G89xt66e8dJKTUcVTjHtKfy8f8AUl0vk+j9Dn9Ph05LijeV24cWSstLtt+S95uztqPZFSNalWVOpCcpRqX+a2qt0lnk1oUdOgxXcne+hvTT7rSrwUe0pdfFeF/b2ZlRAAAAAAAAAAAAAAAAAAAFs3g2vS2Dh6mJq3cIJdxazm3ZJebNEbzfEbaW2HKKqPD0b5UKcnHu+MtX+S8DafxgpTqbNm4/dr4eclzcL2y9Wn6HP1Rxrea+9b9VyA8TxTk227u9273bkeadV1cl0u22eJUJNrmr5NZonYemqGlrpxfFyjNZp9G2k1YD5Ollbx/DduL0bvos7epS2fWalbRXleKvnG+aTztq35MkfKtMuG9tHKD5trJJOKy8SDVhKnOTT733Ek5OUtH6NfQolY1Rprksrxd7ty9PFvVFvoTVFz4euU88sndW56rPwFXGSpxcclOS709ZuPS/JeC158iA53+nKxBcaVWVTiu+UUlf73hl0R4U2nmsuatf9/kUKGIfC6fApcUoty5q3Lpz6E7A4qhRfBUi33pPtLp8Pk1+qKLtuPvBLdvG0sQv5fFGNSH4sO9V52d/NHUODxVPHQhVpyU6c4xlGondSizkqVCE5OSbUXK8YaNQ4W1n1skZdu5vhjt36bpUK1qbcnwSgppSSWiab5526EHRwNZ7n/ElYqfY45wg3K0MUkoxvdq0s8tNVkbJhJTSaaaaumndNAewAAAAAAAAAAAAAAAY38Q6EsRs7EqOvZwlw83aSdl4nNNaMakujTsprI6c33pzq7Pxagry+zzfDa7cFZu3pc5lrqzfn83FZy8QKlGCUc5XlrxWS8uaPSd8stLXyss9bJ65vXqReK37bKkKvX81e/jm2UMRiGmox+d8Tb/qaV7vnmnZEPE4nsbwhnN/PUtd8WeS8Mye6Klp82mln9P0LPVoOnJxeqck2QUErlSMEs5ei5v99SvSo35fmTHhUso2c1lwKXG6sr6JrTLxA+UKKSXDa/dbjZya8Xk8ijXwnEnLmrrh5uyvyXm/RlXDVI05KMtLylTdslqrNPLK1rZlbF16eHfe6T7q4M5NWySSS5ewELBYnWL14ZWd7fdat16excWpK7bS+dXbt0XPyLcpKl/Fj3HwzSXOpJ5NW5JJvP8AwolSvKecm2+bbuBf4Y6jRedS/ek8oOX3r+CMs3X+KFTYNqfeq0O7/BlG1srZO+XLwNYOZ9UrgdW7nb7YPetSVJuFWKvLDyavw9V1Rk5yXuXtqew8Zh8RFtKFWHHG9uKi3Zr1TZ1lCSmk07pq6fVAegAAAAAAAAAAAAHxq5q7e34Twx9SriMJVVKU41Kn2R07xlW1sndcKb8HbyyNpADlnae7eP2Wpyr4WtTjBxUqrpz4Fd2Vno78rMtNv7vuX7p1ri8NTxkJU6sIzpyjwypuPEpR8UYLtv4V7OxlKosOnh60pxnGo5TqRha/ds3o7+f6AaIg3Hk/+DXeemjPNeiq2aylyfX9+Rk+8+4mP3ZgqtWEJ0uOcHVg5zUNLN5Kyd8r81740n/jjvp4MDxhKbo3vr8vlHQlpX68P4bzapRundK6TbuUG76+1rJyfuv05HqDt+9dMtfBgR69OM+7GPFNxjKMdFCNrNtJ66c9dbkSuoYd596prZy4lHzfNlwc1h4uSXft83NydtfBFtVPi11bu3zYEeTlUd37hUbkxUVH65FSNO2n+AIsMIVoYZLP3JNuH6nhtsBCHD09sjZ25nxTr7OUKGLj21CMVFVUrVKcF+TsuTz8TWUKU5uyTfh0iSacI0VqpT0UE7qMurf0QHV2BxdPH04VqUlOlOEZwqLSUGSDDfhNiHX2ZQTi49nOtSu1bitNu68M7eaZmQAAAAAAAAAAAAAAAAHicFUTTSaas4tXTXka533+GFHa/wDFwXBh66jZ4fhUaVVdbJZPxtZ/mbJAHKe2tl1di16mGqq1SnOSclxxU+jV9U+T6ciEpfp+JM6k2xu/gdt8P2nDwquDvGTTTXqrNrw0NQ70fC3HYevOWEgq+HqVZOMFKEHRi22k02lZXtdcugGuppVE4/6VfLKV9fdHzs5R5Ql7wf1RO2rsqtsivPD1VarTqWkr5PK6a6rNBYer2fbdlPslPgdbs3w9ra9r2tfJ5AQb3y4Zr/dCS+h5bj/X/wBa/uSXO+i8skz1icPWw74Z05wla/A6Tg+F6OzQEO6XKT56JfU8qVuSWfPvf2RfNi7sY/b0aksPRlUjTUOKzSvJvRZ5vnboZhu/8HsVi7TxdRYeN79krVKkl42dl7sDXGEwtXHzVOCnUk3FKCV1xeCWRt7cj4XcHDWxq4Vk1g+cv9T5LwVvEz/d/dXAbvR4cPSSlzrPvTfry9LF8ApUKMMPFQhFQhFJRpqKSjFckkVQAAAAAAAAAAAAAAAAAAAAAACDj9k4XaX8+hRq5WTnRhNrybWRHxm7+CxuH+yToQ+zXi1QinTUZJ3TVrNPyLsAMY2buHsjZtSNanhv4kHeMpVq1RRl1Sbav6F3xux8Jj5KdbD0as4x4YznRhUcY3vZXWhcABSoUYYdKMIxhFaQjFRS9EVQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAD/2Q=='),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kategori Sepatu'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CategoryProductsScreen(categoryName: category.name),
                ),
              );
            },
            child: Card(
              clipBehavior: Clip.antiAlias,
              elevation: 4,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    category.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.broken_image, size: 48, color: Colors.grey[400]);
                    },
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                        begin: Alignment.bottomCenter,
                        end: Alignment.center,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    child: Text(
                      category.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        shadows: [Shadow(color: Colors.black, blurRadius: 4)],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}